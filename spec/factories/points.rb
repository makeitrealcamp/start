# == Schema Information
#
# Table name: points
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  course_id  :integer
#  points     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_points_on_course_id  (course_id)
#

FactoryGirl.define do
  factory :point do
    user ""
course nil
points 1
  end

end
