class Billing::ChargesController < ApplicationController

  def create
    charge = Billing::Charge.create!(charge_params.merge(description: "Curso de React y Redux", amount: 299000, tax: 47730, tax_percentage: 0.19, currency: "COP", ip: request.remote_ip))

    send_pending_email(charge)
    ChargeJob.perform_later(charge.id) if charge.credit_card?
    ConvertLoopJob.perform_later(name: "completed-course-charge", person: { pid: cookies['dp_pid'] }, metadata: { course: charge.description, amount: charge.amount.to_f, currency: charge.currency, payment_method: charge.payment_method })

    redirect_to "/billing/charges/#{charge.uid}"
  end

  def update

  end

  def show
    @charge = Billing::Charge.where(uid: params[:id]).take
    render layout: "pages"
  end

  def confirm

  end

  private
    def charge_params
      params.require(:charge).permit(:first_name, :last_name, :email, :payment_method, :card_token, :customer_name, :customer_id_type, :customer_id, :customer_country, :customer_email, :customer_mobile, :customer_address)
    end

    def send_pending_email(charge)
      if charge.credit_card?
        SubscriptionsMailer.charge_validation(charge).deliver_later
      elsif charge.deposit?
        SubscriptionsMailer.charge_instructions(charge).deliver_later
      end
    end
end
