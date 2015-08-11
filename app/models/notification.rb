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
#  index_notifications_on_user_id  (user_id)
#

class Notification < ActiveRecord::Base
  belongs_to :user
  enum status: [:read,:unread]

  # There has to be a partial por each notification_type !
  enum notification_type: [:notice,:level_up,:points_earned,:comment_activity,:comment_response,:badge_earned]

  after_initialize :default_values
  validates :user, presence: true
  validates :status, presence: true
  validates :notification_type, presence: true

  default_scope { order('created_at DESC') }

  private
    def default_values
      self.status ||= Notification.statuses[:unread]
      self.notification_type ||= Notification.notification_types[:notice]
      self.data ||= {}
    end

end
