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

FactoryGirl.define do
  factory :auth_provider do
    user nil
provider "MyString"
uid "MyString"
image "MyString"
  end

end
