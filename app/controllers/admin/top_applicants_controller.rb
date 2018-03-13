class Admin::TopApplicantsController < ApplicationController
	before_action :admin_access

	def index
	  @applicants = TopApplicant.order('created_at DESC')
    if params[:status].present?
      @applicants = @applicants.where(status: TopApplicant.statuses[params[:status]])
    end
    if params[:q].present?
			@applicants = @applicants.where("first_name ILIKE :q OR last_name ILIKE :q OR email ILIKE :q", q: "%#{params[:q]}%")
    end
	end

	def show
	  @applicant = TopApplicant.find(params[:id])
	end

	def aplication_params
	  params.require(:top_applicant).permit(:comment )
	end
end
