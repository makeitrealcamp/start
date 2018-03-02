class Admin::ApplicantActivitiesController < ApplicationController
	def index
	end

	def create 
		

		puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
		puts params
		puts params[:comment_type]
		if params[:comment_type].to_i == 0
			@topApplicant = TopApplicant.find(params[:applicant_id])
			params[:past_status]=@topApplicant.status
	        if params[:status]
	        	@topApplicant.update(:status => params[:status])
			end
			params[:current_status]=@topApplicant.status
			@change_status_application_activity = ChangeStatusApplicationActivity.new(applicant_activity_params)
			@change_status_application_activity.save
		elsif params[:comment_type].to_i == 2
			@email_application_activity = EmailApplicationActivity.new(applicant_activity_params)
			@email_application_activity.save
		elsif params[:comment_type].to_i == 1
			puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
			@applicant_activity= ApplicantActivity.new(applicant_activity_params)
			@applicant_activity.save
		end
			
		# @applicantActivity = ApplicantActivity.new(applicant_activity_params)
		# @applicantActivity.save
		# @email_application_activity = EmailApplicationActivity.new([:subject=>params[:subject],[:body=>params[:body]])
		# @change_status_application_activity = ChangeStatusApplicationActivity.new([:subject=>params[:subject],[:body=>params[:body]])

		redirect_to admin_aplication_path(applicant_activity_params[:applicant_id])
	end

	private
	def applicant_activity_params
	   params[:comment_type]=params[:comment_type].to_i
      params.permit(:comment,:applicant_id,:comment_type,:past_status,:current_status, :subject, :body).merge(user_id: current_user.id)
    end
end
