# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(100)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  last_active_at  :datetime
#  profile         :hstore
#  status          :integer
#  settings        :hstore
#  account_type    :integer
#  nickname        :string
#  level_id        :integer
#  password_digest :string
#  access_type     :integer          default("slack")
#  current_points  :integer          default(0)
#  group_id        :bigint
#
# Indexes
#
#  index_users_on_group_id  (group_id)
#  index_users_on_level_id  (level_id)
#

FactoryGirl.define do
  factory :user do
    sequence (:email) { |n| "user#{n}@example.com" }
    first_name { Faker::Name.first_name }

    sequence(:gender) do |n|
      items = { male: "male", female: "female" }
      items.values[rand(items.size)]
    end

    sequence(:nickname) { |n| "#{Faker::Internet.username(separators: %w(- _))}#{n}" }
    birthday { Faker::Date.between(from: 2.days.ago, to: Time.now) }
    mobile_number { Faker::PhoneNumber.cell_phone }

    activated_at { Faker::Time.between(from: 2.days.ago, to: Time.now) }
    account_type :paid_account

    status :active
    level

    factory :user_with_path do
      after(:create) { |user| user.path_subscriptions.create(path: Path.published.first || create(:path, published: true)) }
    end

    factory :admin_user do
      account_type { User.account_types[:admin_account] }
    end

    factory :admin_with_path do
      account_type  { User.account_types[:admin_account] }
      after(:create) { |user| user.path_subscriptions.create(path: Path.published.first || create(:path,published: true)) }
    end

    factory :user_password do
      access_type { User.access_types[:password] }
    end
  end
end
