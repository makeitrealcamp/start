class Admin::NoteApplicantActivitiesController < ApplicationController
  before_action :admin_access

  def create
    applicant = Applicant.find(params[:applicant_id])
    @activity = applicant.note_activities.create(note_params)
  end

  private
    def note_params
      params.require(:note_applicant_activity).permit(:body).merge(user: current_user)
    end
end
