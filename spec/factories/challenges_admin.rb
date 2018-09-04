# == Schema Information
#
# Table name: challenges
#
#  id                  :integer          not null, primary key
#  subject_id          :integer
#  name                :string(100)
#  instructions        :text
#  evaluation          :text
#  row                 :integer
#  published           :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  slug                :string
#  evaluation_strategy :integer
#  solution_video_url  :string
#  solution_text       :text
#  restricted          :boolean          default(FALSE)
#  preview             :boolean          default(FALSE)
#  pair_programming    :boolean          default(FALSE)
#  difficulty_bonus    :integer
#  timeout             :integer
#
# Indexes
#
#  index_challenges_on_subject_id  (subject_id)
#

FactoryGirl.define do
    factory :challenge do
      subject { create(:subject) }
      name { Faker::Name.title }
      instructions { Faker::Lorem.paragraph }
      published true

    trait :challenge_page do
      name { Faker::Name.title }
      instructions { Faker::Lorem.paragraph }
      difficulty_bonus 20
      timeout 15
      solution_video_url "https://www.youtube.com/embed/52Gg9CqhbP8"
      solution_text { Faker::Lorem.paragraph }
      evaluation_strategy 1
      published true
    end
  end
end
