case Rails.env
when "production"
  Rails.application.config.x.notifications.retrieve_interval_in_millis = 3000
  Rails.application.config.x.notifications.active = true
when "development"
  Rails.application.config.x.notifications.retrieve_interval_in_millis = 3000
  Rails.application.config.x.notifications.active = true
when "test"
  Rails.application.config.x.notifications.retrieve_interval_in_millis = 500
  Rails.application.config.x.notifications.active = false
end
