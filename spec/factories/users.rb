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
#

FactoryGirl.define do
  factory :user do
    sequence (:email) { |n| "user#{n}@example.com" }
    name { Faker::Name.name }
    password "pass1234"
    password_confirmation "pass1234"
    status :active
    roles ["user"]
  end
end
