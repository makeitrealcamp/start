class TopApplicantMailer < ApplicationMailer
  include Roadie::Rails::Automatic
    default from: "german.escobar@makeitreal.camp"
  def top_applicant_mail(user,subject,body)
    body =  body.gsub(/\{\{\s*first_name\s*\}\}/, user.first_name )
    @body = ApplicationController.helpers.markdown(body)
    @user = user
    mail to: user.email, subject: subject
  end
end
