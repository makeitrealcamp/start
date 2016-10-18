# == Schema Information
#
# Table name: points
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  subject_id     :integer
#  points         :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  pointable_id   :integer
#  pointable_type :string
#
# Indexes
#
#  index_points_on_pointable_type_and_pointable_id  (pointable_type,pointable_id)
#  index_points_on_subject_id                       (subject_id)
#

FactoryGirl.define do
  factory :point do
    points 1
    user
    subject
  end

end
