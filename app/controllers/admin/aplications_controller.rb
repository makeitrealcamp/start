class Admin::AplicationsController < ApplicationController
  def index
    @topApplicants = TopApplicant.all

  end

  def show
    @topApplicant = TopApplicant.find(params[:id])
    @comments = ApplicantActivity.all
  end

  def create
  end

  def update
  	puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    @topApplicant = TopApplicant.find(params[:id])
    @topApplicant.update(:status => params[:status])
    @text = aplication_params

  end
  private 

  def aplication_params
  	params.require(:top_applicant).permit(:comment )
  end
end


