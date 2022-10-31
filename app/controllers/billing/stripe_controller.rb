class Billing::StripeController < ApplicationController
  def success
    @stripe_transaction = Stripe::Checkout::Session.retrieve(params[:session_id])
    @payment_result = Stripe::PaymentIntent.retrieve(@stripe_transaction.payment_intent)
    @charge = Billing::Charge.find(@stripe_transaction.metadata.chargeId)
    update_status(@charge, @payment_result)

    render "billing/charges/show", layout: "pages"
  end

  def cancel
    redirect_to full_stack_online_cupo_path( nil, currency: 'USD')
  end

  private

  def update_status(charge, payment)
    if payment.status == "succeeded"
      charge.paid!
    elsif payment.status == "payment_failed"
      charge.rejected!
      charge.error_message = payment.last_payment_error.message
    end
  end

end
