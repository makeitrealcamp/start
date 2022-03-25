class ApplicantMailer < ApplicationMailer
  include Roadie::Rails::Automatic
  default from: "admisiones@makeitreal.camp"

  def email(applicant, subject, body)
    body =  body.gsub(/\{\{\s*first_name\s*\}\}/, applicant.first_name)
    body =  body.gsub(/\{\{\s*uid\s*\}\}/, applicant.uid)
    @body = ApplicationController.helpers.markdown(body)

    mail to: applicant.email, subject: subject
  end

  def invitation(top_invitation)
    @top_invitation = top_invitation
    mail to: top_invitation.email, subject: "[Programa TOP] Código de verificación"
  end
end
