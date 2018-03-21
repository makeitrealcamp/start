class ApplicantMailer < ApplicationMailer
  include Roadie::Rails::Automatic
  default from: "carolina.hernandez@makeitreal.camp"

  def email(applicant, subject, body)
    body =  body.gsub(/\{\{\s*first_name\s*\}\}/, applicant.first_name)
    body =  body.gsub(/\{\{\s*uid\s*\}\}/, applicant.uid)
    @body = ApplicationController.helpers.markdown(body)

    mail to: applicant.email, subject: subject
  end
end
