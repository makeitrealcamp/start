# == Schema Information
#
# Table name: path_subscriptions
#
#  id      :integer          not null, primary key
#  path_id :integer
#  user_id :integer
#
# Indexes
#
#  index_path_subscriptions_on_path_id  (path_id)
#  index_path_subscriptions_on_user_id  (user_id)
#

FactoryGirl.define do
  factory :path_subscription do
    user { create(:user) }
    path { create(:path) }
  end

end
