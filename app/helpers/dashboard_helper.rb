module DashboardHelper
  def next_step
    return 'finished' if @challenge.nil?
    @is_new_challenge ? 'start_challenge' : 'continue_challenge'
  end

  def is_public_notification?(notification)
    notification.notification_type == "level_up" || notification.notification_type == "points_earned" || notification.notification_type == "badge_earned"
  end
end
