class Admin::ChargesController < ApplicationController
  before_action :admin_access

  def index
    @charges = Billing::Charge.order("created_at DESC")
  end

  def show
    @charge = Billing::Charge.find(params[:id])
  end

  def destroy
    charge = Billing::Charge.find(params[:id])
    charge.destroy

    redirect_to admin_charges_path notice: "El pago se ha eliminado con éxito"
  end
end
