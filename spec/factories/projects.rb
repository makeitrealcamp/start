# == Schema Information
#
# Table name: projects
#
#  id                    :integer          not null, primary key
#  subject_id            :integer
#  name                  :string
#  explanation_text      :text
#  explanation_video_url :string
#  published             :boolean
#  row                   :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  difficulty_bonus      :integer          default(0)
#
# Indexes
#
#  index_projects_on_subject_id  (subject_id)
#

FactoryGirl.define do
  factory :project do
    subject { create(:subject) }
    name { Faker::Name.title }
    explanation_text { Faker::Hacker.say_something_smart }
    explanation_video_url { "https://www.youtube.com/embed/52Gg9CqhbP8" }
  end

end
