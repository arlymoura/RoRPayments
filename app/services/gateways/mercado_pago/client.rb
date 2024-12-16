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

      private

      def conn
        Gateways::MercadoPago::Connection.call
      end
    end
  end
end
