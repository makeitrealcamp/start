# == Schema Information
#
# Table name: webinars_webinars
#
#  id          :bigint           not null, primary key
#  title       :string(150)      not null
#  slug        :string(100)      not null
#  description :text
#  date        :datetime         not null
#  image_url   :string
#  event_url   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category    :integer          default("webinar")
#
FactoryGirl.define do
  factory :webinar, class: 'Webinars::Webinar' do
    title { Faker::Company.catch_phrase }
    slug { Faker::Internet.slug }
    description "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

    event_url "d96cjJhvlMA"

    trait :upcoming do
      date { 1.week.from_now }
    end

    trait :past do
      date { 1.week.ago }
    end
  end

end
