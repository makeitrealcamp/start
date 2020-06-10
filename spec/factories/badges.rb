# == Schema Information
#
# Table name: badges
#
#  id              :integer          not null, primary key
#  name            :string
#  description     :text
#  required_points :integer
#  image_url       :string
#  subject_id      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  giving_method   :integer
#

FactoryGirl.define do
  factory :badge do
    subject { create(:subject) }
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.paragraph }
    image_url "/test.png"
    giving_method "manually"

    factory :points_badge do
      giving_method "points"
      required_points 100
    end
  end
end
