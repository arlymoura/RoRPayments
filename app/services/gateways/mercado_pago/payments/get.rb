module Gateways
  module MercadoPago
    module Payments
      class Get
        def initialize(conn, id:)
          @conn = conn
          @id = id
        end

        def call
          return resource if response.status == 200

          Gateways::MercadoPago::LogError.new(
            "Payment Get",
            response,
            { id: @id }
          ).call
          raise Gateways::MercadoPago::Error, error_message
        end

        private

        def error_message
          body.try(:with_indifferent_access).try(:[], "message")
        end

        def resource
          Gateways::MercadoPago::Payments::Parse.new(body).call
        end

        def body
          @body ||= JSON.parse(response.body)
        end

        def response
          @response ||= @conn.get(url)
        end

        def url
          "/v1/payments/#{@id}"
        end
      end
    end
  end
end
