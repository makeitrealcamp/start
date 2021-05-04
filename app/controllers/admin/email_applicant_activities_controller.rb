class Admin::EmailApplicantActivitiesController < ApplicationController
  before_action :admin_access

  def new
    applicant = Applicant.find(params[:applicant_id])
    @activity = applicant.email_activities.build
  end

  def create
    applicant = Applicant.find(params[:applicant_id])
    @activity = applicant.email_activities.create(activity_params)

    if @activity.valid?
      ApplicantMailer.email(applicant, @activity.subject, @activity.body).deliver_now
    end
  end

  private
    def activity_params
      params.require(:email_applicant_activity).permit(:subject, :body).merge(user: current_user)
    end
end
