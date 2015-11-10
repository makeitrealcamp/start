# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(100)
#  roles           :string           is an Array
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  last_active_at  :datetime
#  profile         :hstore
#  status          :integer
#  settings        :hstore
#  account_type    :integer
#  nickname        :string
#  level_id        :integer
#  path_id         :integer
#
# Indexes
#
#  index_users_on_level_id  (level_id)
#  index_users_on_path_id   (path_id)
#

FactoryGirl.define do
  factory :user do
    sequence (:email) { |n| "user#{n}@example.com" }
    password 'mir1234'
    password_confirmation 'mir1234'
    first_name{ Faker::Name.first_name }

    sequence(:gender) do |n|
      items = {male: "male", female: "female"}
      items.values[rand(items.size)]
    end

    birthday { Faker::Time.between(2.days.ago, Time.now)}
    mobile_number { Faker::PhoneNumber.cell_phone }

    sequence(:optimism) do |n|
      items = { high: "high", low: "low" }
      items.values[rand(items.size)]
    end

    sequence(:mindset) do |n|
      items = { growth: "growth", fixed: "fixed" }
      items.values[rand(items.size)]
    end

    sequence(:motivation) do |n|
      items = {job: "job", challenge: "challenge", idea: "idea", impress: "impress", curiosity: "curiosity"}
      items.values[rand(items.size)]
    end

    activated_at { Faker::Time.between(2.days.ago, Time.now) }
    account_type  User.account_types[:free_account]

    association :level, factory: :level

    factory :admin do
      account_type  User.account_types[:admin_account]
    end

    factory :free_user do
      account_type  User.account_types[:free_account]
    end

    factory :paid_user do
      account_type  User.account_types[:paid_account]
    end

    status { User.statuses[:active] }
  end
end
