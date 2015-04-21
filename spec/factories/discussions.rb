# == Schema Information
#
# Table name: discussions
#
#  id           :integer          not null, primary key
#  challenge_id :integer
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryGirl.define do
  factory :discussion do
    challenge nil
title "MyString"
  end

end
