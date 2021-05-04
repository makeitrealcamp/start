class Admin::ChangeStatusApplicantActivitiesController < ApplicationController
  before_action :admin_access

  def new
    applicant = Applicant.find(params[:applicant_id])
    @activity = applicant.change_status_activities.build
  end

  def create
    applicant = Applicant.find(params[:applicant_id])
    applicant.update(status: activity_params[:to_status])

    data = { user: current_user, from_status: applicant.status }
    @activity = applicant.change_status_activities.create(activity_params.merge(data))
  end

  private
    def activity_params
      params.require(:change_status_applicant_activity).permit(:to_status, :comment)
    end
end
