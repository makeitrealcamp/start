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

class PathSubscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :path
end
