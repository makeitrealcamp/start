require 'digest'

class Billing::ChargesController < ApplicationController

  def create
    charge = Billing::Charge.create!(charge_params.merge(charge_data))

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
    @charge = Billing::Charge.where(uid: params[:x_id_invoice]).take
    if @charge.nil?
      @error = "Error"
      render nothing: true, status: :unprocessable_entity
      return
    end

    msg = "#{params[:x_cust_id_cliente]}^#{ENV['EPAYCO_SECRET']}^#{params[:x_ref_payco]}^#{params[:x_transaction_id]}^#{params[:x_amount]}^#{params[:x_currency_code]}"
    signature = Digest::SHA256.hexdigest msg

    data = {
      epayco_approval_code: params[:x_approval_code],
      epayco_transaction_date: params[:x_transaction_date],
      epayco_franchise: params[:x_franchise],
      epayco_card_number: params[:x_cardnumber],
      epayco_bank_name: params[:x_bank_name]
    }

    if signature == params[:x_signature]
      if params[:x_cod_response] == "1"
        @charge.update!(data.merge(status: :paid))
      elsif params[:x_cod_response] == "2" || params[:x_cod_response] == "4"
        @charge.update!(data.merge(status: :rejected, error_message: params[:x_response_reason_text]))
      else
        render nothing: true, status: :unprocessable_entity
        return
      end
      render nothing: true, status: :no_content
    else
      @error = "Error"
      render nothing: true, status: :unprocessable_entity
    end
  end

  private
    def charge_params
      params.require(:charge).permit(:first_name, :last_name, :email,
          :payment_method, :card_token, :customer_name, :customer_id_type,
          :customer_id, :customer_country, :customer_email,
          :customer_mobile, :customer_address)
    end

    def charge_data
      amount = 299000
      tax = 47730

      if params[:coupon].present?
        coupon = Billing::Coupon.where(name: params[:coupon]).take
        if coupon && coupon.is_valid?
          amount = 149000
          tax = 23865
        end
      end

      data = { description: "Curso de React y Redux", amount: amount, tax: tax, tax_percentage: 0.19, currency: "COP", ip: request.remote_ip }
      if params[:coupon].present? && coupon.is_valid?
        data[:coupon] = params[:coupon]
      end
      data
    end

    def send_pending_email(charge)
      if charge.credit_card?
        SubscriptionsMailer.charge_validation(charge).deliver_later
      elsif charge.deposit?
        SubscriptionsMailer.charge_instructions(charge).deliver_later
      end
    end
end
