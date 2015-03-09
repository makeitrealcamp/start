# == Schema Information
#
# Table name: challenges
#
#  id           :integer          not null, primary key
#  course_id    :integer
#  name         :string(100)
#  instructions :text
#  evaluation   :text
#  row          :integer
#  published    :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryGirl.define do
  factory :challenge do
    name{Faker::Name.title}
    instructions {Faker::Lorem.paragraph}
  end
end
