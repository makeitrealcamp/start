# == Schema Information
#
# Table name: projects
#
#  id                    :integer          not null, primary key
#  course_id             :integer
#  name                  :string
#  explanation_text      :text
#  explanation_video_url :string
#  published             :boolean
#  row                   :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

FactoryGirl.define do
  factory :project do
    course { create(:course) }
    name { Faker::Name.title }
    explanation_text { Faker::Hacker.say_something_smart }
    explanation_video_url { "https://www.youtube.com/embed/52Gg9CqhbP8" }
  end

end
