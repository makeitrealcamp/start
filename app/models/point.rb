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
  after_create :check_user_level!


  private

    def check_user_level!
      user.level = Level.for_points(user.stats.total_points)
      user.save!
    end
end
