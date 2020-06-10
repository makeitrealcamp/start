# == Schema Information
#
# Table name: activity_logs
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  activity_id   :integer
#  activity_type :string
#  name          :string
#  description   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_activity_logs_on_activity_type_and_activity_id  (activity_type,activity_id)
#  index_activity_logs_on_user_id                        (user_id)
#

class ActivityLog < ApplicationRecord
  belongs_to :user
  belongs_to :activity, polymorphic: true, optional: true

  validates :user, presence: true
  validates :name, presence: true
  validates :description, presence: true

  after_create :send_event

  private
    def send_event
      unless Rails.env.test?
        ConvertLoopJob.perform_later(name: self.name,
            ocurred_at: self.created_at.utc.to_i,
            person: { email: self.user.email },
            metadata: { "activity-description" => self.description })
      end
    end
end
