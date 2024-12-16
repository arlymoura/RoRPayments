module Gateways
  module MercadoPago
    module Payments
      class Create
        def initialize(conn, data: {})
          @conn = conn
          @data = data
        end

        def call
          return resource if response.success?

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
          @response ||= @conn.post(url) do |request|
            request.body = @data.to_json
            request.headers["Content-Type"] = "application/json"
            request.headers["X-Idempotency-Key"] = payment_attempt_id
          end
        end

        def url
          "/v1/payments"
        end

        def payment_attempt_id
          @data.with_indifferent_access["external_reference"]
        end
      end
    end
  end
end
