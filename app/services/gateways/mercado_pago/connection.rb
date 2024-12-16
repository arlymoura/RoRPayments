module Gateways
  module MercadoPago
    class Connection < ::ApplicationService
      URL = Rails.application.credentials.dig(:mercado_pago, :url) || ENV["MERCADO_PAGO_URL"]
      MERCADO_PAGO_ACCESS_TOKEN = Rails.application.credentials.dig(:mercado_pago, :access_token) || ENV["MERCADO_PAGO_ACCESS_TOKEN"]

      def call
        Faraday.new(
          url: URL,
          headers: { "Authorization" => "Bearer #{MERCADO_PAGO_ACCESS_TOKEN}" }
        )
      end
    end
  end
end
