# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(100)
#  roles           :string           is an Array
#  password_digest :string
#  first_name      :string(50)
#  last_name       :string(50)
#  birthday        :date
#  phone           :string(15)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  last_active_at  :datetime
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
