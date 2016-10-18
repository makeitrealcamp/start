# == Schema Information
#
# Table name: resources
#
#  id            :integer          not null, primary key
#  subject_id    :integer
#  title         :string(100)
#  description   :string
#  row           :integer
#  type_old      :integer
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
#  type          :string(100)
#
# Indexes
#
#  index_resources_on_subject_id  (subject_id)
#

FactoryGirl.define do
  factory :resource do
    title { Faker::Name.title}
    description { Faker::Lorem.paragraph}
    category Resource.categories[:documentation]
    own false
    url { Faker::Internet.url}
    time_estimate {"#{Faker::Number.digit} days"}
    subject
    published true

    factory :external_url, class: ExternalUrl do
      trait :published do
        published true
      end
    end

    factory :video_course, class: Course do
      trait :published do
        published true
      end
    end

    factory :markdown, class: MarkdownDocument do
      trait :published do
        published true
      end
    end

    factory :quiz, class: Quizer::Quiz do
      type "Quizer::Quiz"
      trait :published do
        published true
      end
    end
  end

end
