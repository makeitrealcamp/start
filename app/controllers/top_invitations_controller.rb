class TopInvitationsController < ApplicationController
  def create
    @top_invitation = TopInvitation.where(email: top_invitation_params[:email]).first_or_create
    if @top_invitation.valid?
      ApplicantMailer.invitation(@top_invitation).deliver_now
    end
  end

  def validate
    @top_invitation = TopInvitation.find(params[:id])
    @valid = false
    if @top_invitation.token == params[:token]
      @valid = true
      @applicant = TopApplicant.where(email: @top_invitation.email).order(created_at: :desc).take
      @applicant = TopApplicant.new(email: @top_invitation.email) unless @applicant
    end
  end

  private
    def top_invitation_params
      params.require(:top_invitation).permit(:email)
    end
end
