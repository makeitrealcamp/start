# == Schema Information
#
# Table name: activity_logs
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  activity_id   :integer
#  activity_type :string
#  description   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_activity_logs_on_activity_type_and_activity_id  (activity_type,activity_id)
#  index_activity_logs_on_user_id                        (user_id)
#

class ActivityLog < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity, polymorphic: true

  validates :user, presence: true
  validates :description, presence: true
end
