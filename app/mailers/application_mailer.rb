class ApplicationMailer < ActionMailer::Base
  default from: ENV['MAILER_FROM'] || 'info@makeitreal.camp'
  layout 'mailer'

  helper ApplicationHelper

  def genderize(male, female, user=current_user)
    user.gender == "female" ? female : male
  end
end
