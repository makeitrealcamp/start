class Billing::StripeController < ApplicationController
  def success
    @stripe_transaction = Stripe::Checkout::Session.retrieve(params[:session_id])
    @charge = Billing::Charge.find(@stripe_transaction.metadata.chargeId)
    update_status(@charge, @stripe_transaction.payment_status)
    
    render "billing/charges/show", layout: "pages"
  end

  def cancel
    redirect_to full_stack_online_cupo_path( nil, currency: 'USD')
  end

  private

  def update_status(charge, status)
    if status == "paid"
      charge.paid!
    elsif status == "unpaid"
      charge.pending!
    end
  end

end
