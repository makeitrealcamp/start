class ApplicationMailer < ActionMailer::Base
  default from: Figaro.env.mailer_from
  layout 'mailer'

  helper ApplicationHelper
end
