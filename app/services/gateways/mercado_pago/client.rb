# :reek:UtilityFunction

module Gateways
  module MercadoPago
    class Client < ::ApplicationService

      def find_customer(email)
        Gateways::MercadoPago::Customers::Find.call(email, conn)
      end

      def create_customer(email)
        Gateways::MercadoPago::Customers::Create.call(email, conn)
      end

      def process_payment(attempt)
        Gateways::MercadoPago::Payments::Create.call(conn, data: data)
      end

      def find_payment(attempt)
        Gateways::MercadoPago::Payments::Get.call(conn, id: attempt.gateway_reference).call
      end

      private

      def conn
        Gateways::MercadoPago::Connection.call
      end
    end
  end
end
