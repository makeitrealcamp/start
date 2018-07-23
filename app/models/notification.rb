# == Schema Information
#
# Table name: notifications
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  status            :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  notification_type :integer
#  data              :json
#
# Indexes
#
#  index_notifications_on_created_at  (created_at)
#  index_notifications_on_status      (status)
#  index_notifications_on_user_id     (user_id)
#

class Notification < ApplicationRecord
  PER_PAGE = 10

  belongs_to :user
  enum status: [:read, :unread]

  # there must exists a partial por each notification_type!
  enum notification_type: [ :notice, :level_up, :points_earned,
    :comment_activity, :comment_response, :badge_earned ]

  validates :user, presence: true
  validates :status, presence: true
  validates :notification_type, presence: true

  default_scope { order('created_at DESC') }

  after_initialize :default_values
  after_create :notify_user

  def resource_avaliable?
    if comment_activity?
      Comment.exists?(data["comment_id"])
    elsif comment_response?
      Comment.exists?(data["response_id"])
    elsif badge_earned?
      Badge.exists?(data["badge_id"])
    else
      return true
    end
  end

  private
    def default_values
      self.status ||= Notification.statuses[:unread]
      self.notification_type ||= Notification.notification_types[:notice]
      self.data ||= {}
    end

    def notify_user
      user.notifier.notify('notifications:new', { notification_id: self.id })
    end

end
