Rails.application.config.x.notifications.channel_prefix = ENV["NOTIFICATIONS_CHANNEL_PREFIX"] || "#{Rails.env}_#{Socket.gethostname}"
