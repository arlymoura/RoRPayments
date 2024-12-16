require 'rails_helper'

RSpec.describe Gateways::MercadoPago::Customers::Find do
  let(:email) { "test@example.com" }
  let(:conn) { double("Faraday::Connection") } # Mock da conexão Faraday
  let(:service) { described_class.new(email, conn) }

  describe ".call" do
    context "when the customer exists" do
      let(:successful_response) do
        instance_double(
          Faraday::Response,
          body: {
            results: [{ id: "customer_123" }]
          }.to_json
        )
      end

      it "returns the customer ID" do
        allow(conn).to receive(:get).and_return(successful_response)

        result = service.call

        expect(result).to eq("customer_123")
        expect(conn).to have_received(:get).with("/v1/customers/search?email=#{CGI.escape(email)}")
      end
    end

    context "when the customer does not exist" do
      let(:empty_response) do
        instance_double(
          Faraday::Response,
          body: { results: [] }.to_json
        )
      end

      it "returns nil" do
        allow(conn).to receive(:get).and_return(empty_response)

        result = service.call

        expect(result).to be_nil
        expect(conn).to have_received(:get).with("/v1/customers/search?email=#{CGI.escape(email)}")
      end
    end

    context "when the response body is malformed" do
      let(:malformed_response) do
        instance_double(
          Faraday::Response,
          body: "not a json"
        )
      end

      it "raises a JSON::ParserError" do
        allow(conn).to receive(:get).and_return(malformed_response)

        expect { service.call }.to raise_error(JSON::ParserError)
        expect(conn).to have_received(:get).with("/v1/customers/search?email=#{CGI.escape(email)}")
      end
    end
  end
end
