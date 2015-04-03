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
#

FactoryGirl.define do
  factory :user do
    sequence (:email) { |n| "user#{n}@example.com" }
    password "pass1234"
    first_name{ Faker::Name.first_name }
    last_name{  Faker::Name.first_name }
    phone{ Faker::Number.number(10)}
    birthday{Faker::Date.forward(23)}
    roles ["user"]

    factory :admin do
      roles ["user", "admin"]
    end
  end
end
