# == Schema Information
#
# Table name: top_invitations
#
#  id         :bigint           not null, primary key
#  email      :string
#  token      :string(10)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryGirl.define do
  factory :top_invitation do
    email "MyString"
token "MyString"
  end

end
