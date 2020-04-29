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
#  restricted          :boolean          default("false")
#  preview             :boolean          default("false")
#  pair_programming    :boolean          default("false")
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
    name { Faker::Commerce.product_name }
    instructions { Faker::Lorem.paragraph }
    published true
  end
end
