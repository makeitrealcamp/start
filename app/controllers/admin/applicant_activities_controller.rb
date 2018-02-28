class Admin::ApplicantActivitiesController < ApplicationController
	def index
	end

	def create
		puts "!!!!!!!!!!!!!!!!!!"
		puts params 
		@applicantActivity = ApplicantActivity.new(applicant_activity_params)
		@applicantActivity.save
		redirect_to admin_aplications_path(@applicantActivity.applicant_id)
	end


	private
	def applicant_activity_params
	   params[:comment_type]=params[:comment_type].to_i
      params.permit(:comment,:applicant_id,:comment_type).merge(user_id: current_user.id)
    end
end
