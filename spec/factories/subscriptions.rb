# == Schema Information
#
# Table name: subscriptions
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  status              :integer
#  cancellation_reason :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_subscriptions_on_user_id  (user_id)
#

FactoryGirl.define do
  factory :subscription do
    user { create(:user) }
    status :active
  end

end
