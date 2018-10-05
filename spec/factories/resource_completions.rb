# == Schema Information
#
# Table name: resources_users
#
#  resource_id :integer
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_resources_users_on_resource_id_and_user_id  (resource_id,user_id) UNIQUE
#

FactoryGirl.define do
  factory :resource_completion do
    association  :user, factory: :user
    association  :resource, factory: :resource
  end
end
