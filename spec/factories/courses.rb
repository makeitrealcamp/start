# == Schema Information
#
# Table name: courses
#
#  id            :integer          not null, primary key
#  name          :string(50)
#  row           :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  time_estimate :string(50)
#  excerpt       :string
#  description   :string
#  slug          :string
#  published     :boolean
#  phase_id      :integer
#  phase         :integer
#
# Indexes
#
#  index_courses_on_phase_id  (phase_id)
#

FactoryGirl.define do
  factory :course do
    name { Faker::Name.title }
    excerpt { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    phase { create(:phase) }
    published true
  end
end
