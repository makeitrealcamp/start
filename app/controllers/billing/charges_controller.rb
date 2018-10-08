require 'digest'

class Billing::ChargesController < ApplicationController

  def create
    @charge = Billing::Charge.create!(charge_params.merge(charge_data))
    @signature = signature(@charge)

    ConvertLoopJob.perform_later(name: "completed-course-charge", person: { pid: cookies['dp_pid'] }, metadata: { course: @charge.description, amount: @charge.amount.to_f, currency: @charge.currency, payment_method: @charge.payment_method })
    render layout: false
  end

  def update

  end

  def show
    @charge = Billing::Charge.where(uid: params[:id]).take
    render layout: "pages"
  end

  private
    def charge_params
      params.require(:charge).permit(:first_name, :last_name, :email,
          :description, :customer_name, :customer_id_type,
          :customer_id, :customer_country, :customer_email,
          :customer_mobile, :customer_address)
    end

    def charge_data
      courses[params[:course].to_sym].merge({ ip: request.remote_ip })
    end

    def signature(charge)
      msg = "#{ENV['PAYU_API_KEY']}~#{ENV['PAYU_MERCHANT_ID']}~#{charge.uid}~500000~COP"
      Digest::MD5.hexdigest(msg)
    end

    def courses
      {
        nodejs: {
          description: "Separación curso de Express y MongoDB",
          amount: 500_000,
          tax: 0,
          tax_percentage: 0,
          currency: "COP",
        },
        react: {
          description: "Separación curso de React y Redux",
          amount: 500_000,
          tax: 0,
          tax_percentage: 0,
          currency: "COP",
        }
      }
    end
end
