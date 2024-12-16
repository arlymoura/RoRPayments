class PaymentsController < ApplicationController
  def new
  end

  def create
    service = Payments::Create.call(
      name: params[:name],
      email: params[:email],
      amount: params[:amount].to_f,
      description: "Payment for order #{SecureRandom.hex(5)}",
      payment_method_id: "boleto"
    )

    redirect_to payment_path(service.id), notice: "Payment successfully created!"
  rescue StandardError => e
    redirect_to new_payment_path, alert: "Error processing payment: #{e.message}"
  end

  def show
    @payment = Payment.find(params[:id])
  end
end
