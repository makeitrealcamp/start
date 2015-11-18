class ApplicationMailer < ActionMailer::Base
  default from: Settings.action_mailer.default_from
  layout 'mailer'

  helper ApplicationHelper
end
