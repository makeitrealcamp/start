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
      metadata = {}
      if activity_params[:to_status] == 'rejected'
        metadata[:rejection_reason] = activity_params[:rejected_reason]
      end
      notify_convertloop(applicant.class.status_segments(activity_params[:to_status]), applicant, metadata)
    end

    data = { user: current_user, from_status: from_status }
    @activity = applicant.change_status_activities.create(activity_params.merge(data))
  end

  private
    def activity_params
      params.require(:change_status_applicant_activity).permit(:to_status, :comment, :rejected_reason, :second_interview_substate, :first_interview_substatus, :gave_up_reason)
    end

    def notify_convertloop(event, applicant, metadata)
      ConvertLoop.event_logs.send(
        name: event,
        person: {
          email: applicant.email
        },
        metadata: metadata
      )
    rescue => e
      Rails.logger.error "Couldn't send event to ConvertLoop: #{e.message}"
    end
end
