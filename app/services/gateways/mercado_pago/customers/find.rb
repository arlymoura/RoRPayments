module Gateways
  module MercadoPago
    module Customers
      class Find < ::ApplicationService
        def initialize(email, conn)
          @email = email
          @conn = conn
        end

        def call
          resource
        end

        private

        attr_reader :email, :conn

        def body
          @body ||= JSON.parse(response.body)
        end

        def resource
          body.dig("results", 0, "id")
        end

        def response
          @response ||= conn.get(url)
        end

        def url
          "/v1/customers/search?email=#{CGI.escape(email)}"
        end
      end
    end
  end
end
