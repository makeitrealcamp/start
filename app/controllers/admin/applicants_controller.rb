class Admin::ApplicantsController < ApplicationController
	def index
	  @topApplicants = TopApplicant.all
	  @comments = ApplicantActivity.all.order("created_at DESC")
	  puts @comments
	end

	def show
	  @topApplicant = TopApplicant.find(params[:id])
	  @comments = ApplicantActivity.all.order("created_at DESC")
	  puts @comments
	end

	def create
	end

	def update

	end
	private 

	def aplication_params
	  params.require(:top_applicant).permit(:comment )
	end
end