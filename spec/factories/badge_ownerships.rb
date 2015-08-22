# == Schema Information
#
# Table name: badge_ownerships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  badge_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :badge_ownerships do
    association  :user, factory: :user
    association  :badge, factory: :badge
  end
end
