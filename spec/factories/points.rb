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

FactoryGirl.define do
  factory :point do
    points 1
    association :user, factory: :user
    association :course, factory: :course
  end

end
