# == Schema Information
#
# Table name: auth_providers
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  provider   :string
#  uid        :string
#  image      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_auth_providers_on_user_id  (user_id)
#

FactoryGirl.define do
  factory :auth_provider do
    uid "12345"
    association  :user, factory: :user
  end

end
