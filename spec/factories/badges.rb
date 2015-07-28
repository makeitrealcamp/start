# == Schema Information
#
# Table name: badges
#
#  id              :integer          not null, primary key
#  name            :string
#  description     :text
#  required_points :integer
#  image_url       :string
#  course_id       :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  giving_method   :integer
#

FactoryGirl.define do
  factory :badge do
    name { Faker::Name.title }
    description { Faker::Lorem.paragraph }
    image_url Faker::Avatar.image
    giving_method "manually"
    factory :manually_assigned_badge do
      giving_method "manually"
    end
    factory :points_badge do
      giving_method "points"
      association  :course, factory: :course
      required_points 100
    end

  end
end
