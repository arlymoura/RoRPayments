require 'rails_helper'

RSpec.describe Payments::Create, type: :service do
  let(:email) { 'customer@example.com' }
  let(:amount) { 100.0 }
  let(:description) { 'Payment for order #12345' }
  let(:payment_method_id) { 'boleto' } # Usando boleto como exemplo
  let(:conn) { instance_double('Faraday::Connection') }
  let(:service) { described_class.new(email, amount, description, payment_method_id, conn) }

  describe '#call' do
    context 'when payment is successful' do
      let(:payment_response) do
        {
          'status' => 'approved',
          'external_id' => 'MP123456789',
          'transaction_details' => { 'total_paid_amount' => amount }
        }
      end

      before do
        # Mocking the response of the MercadoPago API
        allow(conn).to receive(:post).and_return(double('response', status: 200, body: payment_response.to_json))
      end

      it 'returns a payment object with the correct details' do
        payment = service.call

        expect(payment).to be_a(Payment)
        expect(payment.external_id).to eq('MP123456789')
        expect(payment.status).to eq('approved')
        expect(payment.amount).to eq(amount)
      end
    end

    context 'when payment fails' do
      let(:error_response) do
        {
          'status' => 'rejected',
          'cause' => 'Invalid card details'
        }
      end

      before do
        # Mocking the response of the MercadoPago API for a failed payment
        allow(conn).to receive(:post).and_return(double('response', status: 400, body: error_response.to_json))
      end

      it 'raises an error with the correct message' do
        expect { service.call }.to raise_error(Gateways::MercadoPago::Error, 'Invalid card details')
      end
    end

    context 'when the API returns an error' do
      before do
        # Mocking an error in the API request
        allow(conn).to receive(:post).and_raise(Faraday::Error::TimeoutError)
      end

      it 'raises an error' do
        expect { service.call }.to raise_error(Faraday::Error::TimeoutError)
      end
    end
  end
end
