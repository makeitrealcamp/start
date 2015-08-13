# == Schema Information
#
# Table name: levels
#
#  id              :integer          not null, primary key
#  name            :string
#  required_points :integer
#  image_url       :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :level do
    name "teclado blanco"
    required_points 0
    image_url { Faker::Avatar.image }
    factory :level_1 do
      name "Level 1"
      required_points 100
    end
    factory :level_2 do
      name "Level 2"
      required_points 200
    end
  end
end
