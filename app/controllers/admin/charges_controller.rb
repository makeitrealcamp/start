class Admin::ChargesController < ApplicationController
  before_action :admin_access

  def index
    @charges = Billing::Charge.order("created_at DESC")
  end

  def show
    @charge = Billing::Charge.find(params[:id])
  end

  def new
    @charge = Billing::Charge.new
  end

  def create
    charge = Billing::Charge.new(charge_params.merge(payment_method: :deposit))
    if charge.save
      redirect_to admin_charge_path(charge)
    else
      render :new
    end
  end

  def edit
    @charge = Billing::Charge.find(params[:id])
  end

  def update
    charge = Billing::Charge.find(params[:id])
    if charge.update(charge_params)
      redirect_to admin_charge_path(charge)
    else
      render :edit
    end
  end

  def destroy
    charge = Billing::Charge.find(params[:id])
    charge.destroy

    redirect_to admin_charges_path notice: "El pago se ha eliminado con éxito"
  end

  private
    def charge_params
      params.require(:billing_charge).permit(:first_name, :last_name, :email,
          :description, :currency, :amount, :tax_percentage, :tax, :status,
          :customer_name, :customer_email, :customer_type_id, :customer_id,
          :customer_country, :customer_mobile, :customer_address)
    end
end
