module Customers
  class ExternalFindOrCreate < ::ApplicationService
    def initialize(email:)
      @email = email
    end

    def call
      customer || create_customer
    rescue Gateways::Error => error
      raise ::Customers::Error, error.message
    end

    private

    def customer
      @customer ||= Gateways::MercadoPago::Client.find_customer(@email)
    end

    def create_customer
      @create_customer ||= Gateways::MercadoPago::Client.create_customer(@email)
    end
  end
end
