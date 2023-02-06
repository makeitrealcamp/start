class Admin::ChangeStatusApplicantActivitiesController < ApplicationController
  before_action :admin_access

  def new
    applicant = Applicant.find(params[:applicant_id])
    @activity = applicant.change_status_activities.build
  end

  def create
    applicant = Applicant.find(params[:applicant_id])
    from_status = applicant.status
    applicant.update(status: activity_params[:to_status])
    if applicant.type == 'TopApplicant'
      ConvertLoop.event_logs.send(
        name: applicant.class.status_segments(activity_params[:to_status]),
        person: {
          email: applicant.email
        },
        metadata: { 
          rejection_reason: activity_params[:rejected_reason],
          second_interview_substate: activity_params[:second_interview_substate]
        }
      )
      
    end

    data = { user: current_user, from_status: from_status }
    @activity = applicant.change_status_activities.create(activity_params.merge(data))
  end

  private
    def activity_params
      params.require(:change_status_applicant_activity).permit(:to_status, :comment, :rejected_reason, :second_interview_substate)
    end
end
