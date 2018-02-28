class Admin::AplicationsController < ApplicationController
  def index
    @topApplicants = TopApplicant.all
  end

  def show
    @topApplicant = TopApplicant.find(params[:id])
  end

  def create
  	puts "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
  	puts params
  	puts params[:task_id]
  	puts params[:status]
  	puts aplication_params	
  	@topApplicant = TopApplicant.find(params[:task_id])
  	@topApplicant.update(:status => params[:status])
  	puts @topApplicant 

  end

  def update
  	puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  end
  private 

  def aplication_params
  	params.require(:top_applicant).permit(:comment )
  end
end
