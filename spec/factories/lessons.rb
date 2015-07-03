# == Schema Information
#
# Table name: lessons
#
#  id             :integer          not null, primary key
#  section_id     :integer
#  name           :string
#  video_url      :string
#  description    :text
#  row            :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  free_preview   :boolean          default(FALSE)
#  info           :text
#  video_duration :string
#
# Indexes
#
#  index_lessons_on_section_id  (section_id)
#

FactoryGirl.define do

  factory :lesson do
    section { create(:section) }
    name { Faker::Lorem.word }
    video_url { Faker::Internet.url }
    description { Faker::Lorem.paragraph }
    row 1
    factory :paid_lesson do
      free_preview false
    end
    factory :free_lesson do
      free_preview true
    end
  end

end
