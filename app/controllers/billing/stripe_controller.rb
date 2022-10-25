class Billing::StripeController < ApplicationController
  def success
    @stripeTransaction = Stripe::Checkout::Session.retrieve(params[:session_id])
    @charge = Billing::Charge.find(@stripeTransaction.metadata.chargeId)
    render "billing/charges/stripe/show", layout: "pages"
  end

  def cancel
    redirect_to full_stack_online_cupo_path( nil, currency: 'USD')
  end

end
