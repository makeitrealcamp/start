class UserNotifier


  attr_accessor :user, :notification_service, :channel

  def initialize(user,notification_service = Pusher)
    @user = user
    @notification_service = notification_service
  end

  def channel
    "#{Rails.application.config.x.notifications.channel_prefix}_user_#{@user.id}"
  end

  def notify(event,data)
    puts "#{Pusher.url}!!!!!!!!!!!!!!!!!!!!!!"
    @notification_service.trigger(channel, 'notifications:new',data)
  end
end
