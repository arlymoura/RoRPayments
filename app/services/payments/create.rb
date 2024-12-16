module Payments
  class Create < ::ApplicationService
    def initialize(name:, email:, amount:)
      @name = name
      @email = email
      @amount = amount
      @description = "Payment for order #{SecureRandom.hex(5)}"
      @customer = nil
      @payment_record = nil
      @local_customer = nil
    end

    def call
      find_or_create_local_customer
      create_payment_record
      process_payment
    end

    private

    attr_reader :name, :email, :amount, :description, :local_customer, :payment_record

    # 1. Buscar ou criar cliente local
    def find_or_create_local_customer
      @local_customer = Customer.find_by(email: email)

      unless @local_customer
        external_id = Customers::ExternalFindOrCreate.call(email: email)
        @local_customer = Customer.create!(
          name: name,
          email: email,
          external_id: external_id
        )
      end
    end

    # 2. Criar registro do pagamento no banco
    def create_payment_record
      @payment_record = Payment.create!(
        customer: local_customer,
        amount: amount,
        description: description,
        status: "processing" # Status inicial
      )
    end

    # 3. Processar pagamento no Mercado Pago (agora sem token, para boleto)
    def process_payment
      service = Gateways::MercadoPago::Payments::Create.call(conn: client.connection ,data: data)
      handle_payment_response(service)
    end

    # Dados enviados ao Mercado Pago (sem token para boleto)
    def data
      {
        transaction_amount: amount,
        description: description,
        payment_method_id: "boleto", # "boleto" para boleto
        payer: {
          name: name,
          email: email
        }
      }
    end

    # Tratamento da resposta do Mercado Pago
    def handle_payment_response(response)
      if response.success?
        payment_record.update!(external_id: body["id"])
        Gateways::MercadoPago::Payments::Parse.new(body).call
      else
        raise Gateways::MercadoPago::Error, body.dig("cause", 0, "description")
      end
    end

    # URL da API do Mercado Pago
    def url
      "/v1/payments"
    end


    def client
      @client ||= MercadoPago::Client.new
    end
  end
end
