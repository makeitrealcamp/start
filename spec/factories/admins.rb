# == Schema Information
#
# Table name: admins
#
#  id              :bigint           not null, primary key
#  email           :string(100)
#  password_digest :string
#  permissions     :text             default([]), is an Array
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
FactoryGirl.define do
  factory :admin do
    sequence (:email) { |n| "user#{n}@example.com" }
    password "test1234"
    permissions []
  end

end
