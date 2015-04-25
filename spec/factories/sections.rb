# == Schema Information
#
# Table name: sections
#
#  id          :integer          not null, primary key
#  resource_id :integer
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :section do
    course_id 1
title "MyString"
  end

end
