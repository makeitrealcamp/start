case Rails.env
when "production"
  Rails.application.config.x.notifications.active = true
  Rails.application.config.x.notifications.logging = false
when "development"
  Rails.application.config.x.notifications.active = true
  Rails.application.config.x.notifications.logging = true
when "test"
  Rails.application.config.x.notifications.active = false
  Rails.application.config.x.notifications.logging = false
end
