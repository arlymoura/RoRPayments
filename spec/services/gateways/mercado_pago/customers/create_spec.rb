require 'rails_helper'

RSpec.describe Gateways::MercadoPago::Customers::Create do
  let(:email) { "test@example.com" }
  let(:conn) { double("Faraday::Connection") } # Simula a conexão Faraday
  let(:service) { described_class.new(email, conn) }

  describe ".call" do
    context "when the API call is successful" do
      let(:successful_response) do
        instance_double(
          Faraday::Response,
          success?: true,
          body: { id: "customer_123" }.to_json
        )
      end

      it "returns the customer ID" do
        allow(conn).to receive(:post).and_return(successful_response)

        result = service.call

        expect(result).to eq("customer_123")
        expect(conn).to have_received(:post).with("/v1/customers")
      end
    end

    context "when the API call fails" do
      let(:error_response) do
        instance_double(
          Faraday::Response,
          success?: false,
          body: {
            cause: [{ description: "Invalid email format" }]
          }.to_json
        )
      end

      it "raises a Gateways::MercadoPago::Error with the error description" do
        allow(conn).to receive(:post).and_return(error_response)

        expect { service.call }.to raise_error(
          Gateways::MercadoPago::Error,
          "Invalid email format"
        )
        expect(conn).to have_received(:post).with("/v1/customers")
      end
    end

    context "when the response body is malformed" do
      let(:malformed_response) do
        instance_double(
          Faraday::Response,
          success?: false,
          body: "not a json"
        )
      end

      it "raises a JSON::ParserError" do
        allow(conn).to receive(:post).and_return(malformed_response)

        expect { service.call }.to raise_error(JSON::ParserError)
        expect(conn).to have_received(:post).with("/v1/customers")
      end
    end
  end
end
