class Billing::StripeController < ApplicationController
  def success
    @stripe_transaction = Stripe::Checkout::Session.retrieve(params[:session_id])
    @charge = Billing::Charge.find(@stripe_transaction.metadata.chargeId)
    @charge.status =  @stripe_transaction.payment_status.to_sym
    render "billing/charges/stripe/show", layout: "pages"
  end

  def cancel
    redirect_to full_stack_online_cupo_path( nil, currency: 'USD')
  end

end
