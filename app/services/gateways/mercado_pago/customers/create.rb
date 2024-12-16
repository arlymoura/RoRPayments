module Gateways
  module MercadoPago
    module Customers
      class Create < ::ApplicationService
        def initialize(email, conn)
          @email = email
          @conn = conn
        end

        def call
          return resource if response.success?

          raise Gateways::MercadoPago::Error, description_error
        end

        private

        attr_reader :email, :conn

        def body
          @body ||= JSON.parse(response.body)
        end

        def resource
          body["id"]
        end

        def response
          @response ||= conn.post(url) do |request|
            request.body = data.to_json
            request.headers["Content-Type"] = "application/json"
          end
        end

        def data
          { email: email }
        end

        def description_error
          body.try(:with_indifferent_access).try(:[], "cause").try(:[], 0).try(:[], "description")
        end

        def url
          "/v1/customers"
        end
      end
    end
  end
end
