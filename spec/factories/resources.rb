# == Schema Information
#
# Table name: resources
#
#  id            :integer          not null, primary key
#  subject_id    :integer
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
#  index_resources_on_subject_id  (subject_id)
#

FactoryGirl.define do
  factory :resource do
    title { Faker::Name.title}
    description { Faker::Lorem.paragraph}
    type :url
    category Resource.categories[:documentation]
    own false
    url { Faker::Internet.url}
    time_estimate {"#{Faker::Number.digit} days"}
    subject
    published true

    factory :video_subject do
      type Resource.types[:course]
      trait :published do
        published true
      end
    end
  end

end
