class ApplicationMailer < ActionMailer::Base
  default from: ENV['MAILER_FROM'] || 'info@makeitreal.camp'
  layout 'mailer'

  helper ApplicationHelper
end
