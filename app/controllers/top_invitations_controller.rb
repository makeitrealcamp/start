class TopInvitationsController < ApplicationController
  def create
    @top_invitation = TopInvitation.where(email: top_invitation_params[:email]).first_or_create
    if @top_invitation.valid?
      ApplicantMailer.invitation(@top_invitation).deliver_later

      data = {
        name: "created-top-token",
        person: {
          pid: cookies[:dp_pid],
          email: @top_invitation.email
        }
      }
      ConvertLoopJob.perform_later(data)
    end
  end

  def validate
    @top_invitation = TopInvitation.find(params[:id])
    @valid = false
    if @top_invitation.token == params[:token]
      @valid = true
      @applicant = TopApplicant.where(email: @top_invitation.email).order(created_at: :desc).take
      @applicant = TopApplicant.new(email: @top_invitation.email) unless @applicant
      ConvertLoopJob.perform_later(name: "validated-top-token", person: { email: @top_invitation.email })
    end
  end

  private
    def top_invitation_params
      params.require(:top_invitation).permit(:email)
    end
end
