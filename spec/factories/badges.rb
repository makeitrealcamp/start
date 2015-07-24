# == Schema Information
#
# Table name: badges
#
#  id             :integer          not null, primary key
#  name           :string
#  description    :text
#  require_points :integer
#  image_url      :string
#  course_id      :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryGirl.define do
  factory :badge do
    name { Faker::Name.title }
    description { Faker::Lorem.paragraph }
    require_points 0
    image_url Faker::Avatar.image
    association  :course, factory: :course
  end
end
