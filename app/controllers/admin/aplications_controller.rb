class Admin::AplicationsController < ApplicationController
  def index
    @topApplicants = TopApplicant.all
  end

  def show
    @topApplicant = TopApplicant.find(params[:id])
  end
end
