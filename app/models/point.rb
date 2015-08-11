# == Schema Information
#
# Table name: points
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  course_id      :integer
#  points         :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  pointable_id   :integer
#  pointable_type :string
#
# Indexes
#
#  index_points_on_course_id                        (course_id)
#  index_points_on_pointable_type_and_pointable_id  (pointable_type,pointable_id)
#

class Point < ActiveRecord::Base
  belongs_to :course
  belongs_to :user
  belongs_to :pointable, polymorphic: true

  validates :user, presence: true

  after_create :notify_user
  after_create :check_user_level!
  after_create :check_user_badges!

  private

    def check_user_level!
      new_level = Level.for_points(user.stats.total_points)
      unless new_level.nil?
        user.level = new_level
        user.save!
      end
    end

    def check_user_badges!
      new_badges = Badge.granted_by_points
        .where.not(id: self.user.badges)
        .where(course_id: self.course)
        .where("required_points <= ?",self.user.stats.points_per_course(self.course))
      user.badges << new_badges
    end

    def notify_user
      user.notifications.create!(notification_type: :points_earned, data: {point_id: self.reload.id})
    end
end
