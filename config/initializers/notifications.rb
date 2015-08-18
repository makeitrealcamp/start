case Rails.env
when "production"
  Rails.application.config.x.notifications.active = true
  Rails.application.config.x.notifications.logging = false
  Rails.application.config.x.notifications.channel_prefix = ENV["NOTIFICATIONS_CHANNEL_PREFIX"]
when "development"
  Rails.application.config.x.notifications.active = true
  Rails.application.config.x.notifications.logging = true
  # Avoid messages from different development environments using a random prefix for the users' channel
  Rails.application.config.x.notifications.channel_prefix = ENV["NOTIFICATIONS_CHANNEL_PREFIX"] || "development_#{Socket.gethostname}"
when "test"
  Rails.application.config.x.notifications.active = false
  Rails.application.config.x.notifications.logging = false
  Rails.application.config.x.notifications.channel_prefix = ENV["NOTIFICATIONS_CHANNEL_PREFIX"] || "test_#{Socket.gethostname}"
end
