class Admin::AplicationsController < ApplicationController
  def index
    @participants = TopApplicant.all
  end

  def show
    @participant = TopApplicant.find(params[:id])
  end
end
