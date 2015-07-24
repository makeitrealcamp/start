# == Schema Information
#
# Table name: notifications
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  message    :text
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_notifications_on_user_id  (user_id)
#

class Notification < ActiveRecord::Base
  belongs_to :user
  enum status: [:read,:unread]

  after_initialize :default_values
  validates :message, presence: true
  validates :user, presence: true
  validates :status, presence: true


  private
  def default_values
    self.status ||= Notification.statuses[:unread]
  end
end
