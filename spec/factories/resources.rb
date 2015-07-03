# == Schema Information
#
# Table name: resources
#
#  id            :integer          not null, primary key
#  course_id     :integer
#  title         :string(100)
#  description   :string
#  row           :integer
#  type          :integer
#  url           :string
#  time_estimate :string(50)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  content       :text
#  slug          :string
#  published     :boolean
#  video_url     :string
#  category      :integer
#  own           :boolean
#
# Indexes
#
#  index_resources_on_course_id  (course_id)
#

FactoryGirl.define do
  factory :resource do
    title { Faker::Name.title}
    description { Faker::Lorem.paragraph}
    type Resource.types[:url]
    category Resource.categories[:documentation]
    own false
    url { Faker::Internet.url}
    time_estimate {"#{Faker::Number.digit} days"}
    association  :course, factory: :course
    published true
    factory :video_course do
      type Resource.types[:course]
      factory :published_video_course do
        published true
      end
    end
  end

end
