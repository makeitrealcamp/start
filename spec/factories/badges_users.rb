# == Schema Information
#
# Table name: badges_users
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  badge_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :badges_user do
    user_id 1
badge_id 1
  end

end
