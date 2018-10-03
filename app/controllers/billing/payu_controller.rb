class Billing::PayuController < ApplicationController
  def result
    @charge = Billing::Charge.where(uid: params[:referenceCode]).take

    if response_signature(@charge) == params[:signature]
      @charge.status = :pending
    else
      @charge.status = :error
      @charge.error_message = "La firma en la respuesta no es válida."
    end

    render "billing/charges/show", layout: "pages"
  end

  def confirm
    charge = Billing::Charge.where(uid: params[:reference_sale]).take
    if charge.nil?
      render nothing: true, status: :unprocessable_entity
      return
    end

    if confirm_signature(charge) == params[:sign]
      update_status(charge, params[:state_pol])
      update_payment_method(charge, params[:payment_method_type])
      head :ok
    else
      charge.error!
      render nothing: true, status: :unprocessable_entity
    end
  end

  private
    def response_signature(charge)
      new_value = sprintf("%.1f", BigDecimal(params[:TX_VALUE]))
      msg = "#{ENV['PAYU_API_KEY']}~#{params[:merchantId]}~#{params[:referenceCode]}~#{new_value}~#{params[:currency]}~#{params[:transactionState]}"
      Digest::MD5.hexdigest(msg)
    end

    def confirm_signature(charge)
      new_value = sprintf("%.1f", BigDecimal(params[:value]))
      msg = "#{ENV['PAYU_API_KEY']}~#{params[:merchant_id]}~#{params[:reference_sale]}~#{new_value}~#{params[:currency]}~#{params[:state_pol]}"
      Digest::MD5.hexdigest(msg)
    end

    def update_status(charge, status)
      if status == "4"
        charge.paid!
      elsif status == "7"
        charge.pending!
      elsif status == "6"
        charge.rejected!
        charge.update(error_message: params[:response_message_pol])
      end
    end

    def update_payment_method(charge, payment_method)
      if payment_method == "2"
        charge.credit_card!
      elsif payment_method == "4"
        charge.pse!
      elsif payment_method == "6"
        charge.debit_card!
      elsif payment_method == "7"
        charge.cash!
      elsif payment_method == "8" || payment_method == "10"
        charge.referenced!
      elsif payment_method == "14"
        charge.transfer!
      end
    end
end
