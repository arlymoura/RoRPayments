require 'rails_helper'

RSpec.describe Customers::ExternalFindOrCreate do
  let(:email) { "test@example.com" }
  let(:service) { described_class.new(email: email) }

  let(:mocked_client) { instance_double(Gateways::MercadoPago::Client) }
  let(:mocked_customer) { { id: "123", email: email } }

  before do
    allow(Gateways::MercadoPago::Client).to receive(:find_customer).and_return(nil)
    allow(Gateways::MercadoPago::Client).to receive(:create_customer).and_return(mocked_customer)
  end

  describe ".call" do
    context "when the customer already exists" do
      it "returns the existing customer" do
        allow(Gateways::MercadoPago::Client).to receive(:find_customer).with(email).and_return(mocked_customer)

        result = service.call

        expect(result).to eq(mocked_customer)
        expect(Gateways::MercadoPago::Client).to have_received(:find_customer).with(email)
        expect(Gateways::MercadoPago::Client).not_to have_received(:create_customer)
      end
    end

    context "when the customer does not exist" do
      it "creates a new customer" do
        allow(Gateways::MercadoPago::Client).to receive(:find_customer).with(email).and_return(nil)

        result = service.call

        expect(result).to eq(mocked_customer)
        expect(Gateways::MercadoPago::Client).to have_received(:find_customer).with(email)
        expect(Gateways::MercadoPago::Client).to have_received(:create_customer).with(email)
      end
    end

    context "when there is an error in the gateway" do
      it "raises a Customers::Error" do
        allow(Gateways::MercadoPago::Client).to receive(:find_customer).with(email).and_raise(Gateways::Error.new("API error"))

        expect { service.call }.to raise_error(Customers::Error, "API error")
      end
    end
  end
end
