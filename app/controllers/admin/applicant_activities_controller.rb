class Admin::ApplicantActivitiesController < ApplicationController
	def index
	end

	def create
		@topApplicant = TopApplicant.find(params[:applicant_id])
		params[:past_status]=@topApplicant.status
        if params[:status]
        	@topApplicant.update(:status => params[:status])
		end
		params[:current_status]=@topApplicant.status

		@applicantActivity = ApplicantActivity.new(applicant_activity_params)
		@applicantActivity.save
		@email_application_activity = EmailApplicationActivity.new([:subject=>params[:subject],[:body=>params[:body]])
		@change_status_application_activity = ChangeStatusApplicationActivity.new([:subject=>params[:subject],[:body=>params[:body]])

		redirect_to admin_aplication_path(@applicantActivity.applicant_id)
	end

	private
	def applicant_activity_params
	   params[:comment_type]=params[:comment_type].to_i
      params.permit(:comment,:applicant_id,:comment_type,:past_status,:current_status, :subject, :body).merge(user_id: current_user.id)
    end
end
