class Admin::ApplicantsController < ApplicationController
	def index
	  @topApplicants = TopApplicant.all
    if params[:status]
      status_num = TopApplicant.statuses[params[:status]]
      @topApplicants = @topApplicants.where(status: status_num)
    end
    if params[:search] && params[:search] != "" 
      @topApplicants_name = @topApplicants.where(first_name: params[:search])
      p "!!!!!!!!!!!!"
      p @topApplicants_name
      @topApplicants_email = @topApplicants.where(email: params[:search])
     p "!!!!!!!!!!!!"
      p@topApplicants_email
      p "!!!!!!!!!!!!"
      @topApplicants = @topApplicants_name.concat(@topApplicants_email)
    end
	end

	def show
	  @topApplicant = TopApplicant.find(params[:id])
	  @comments = ApplicantActivity.all.order("created_at DESC")
	end

	def aplication_params
	  params.require(:top_applicant).permit(:comment )
	end
end