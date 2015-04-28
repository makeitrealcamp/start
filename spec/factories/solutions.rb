# == Schema Information
#
# Table name: solutions
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  challenge_id :integer
#  status       :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  attempts     :integer
#  properties   :hstore
#

FactoryGirl.define do
  factory :solution do
    association  :user, factory: :user
    association  :challenge, factory: :challenge
  end
end
