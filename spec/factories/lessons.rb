# == Schema Information
#
# Table name: lessons
#
#  id          :integer          not null, primary key
#  section_id  :integer
#  name        :string
#  video_url   :string
#  description :text
#  row         :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :lesson do
    section nil
name "MyString"
video_url "MyString"
description "MyText"
position 1
  end

end
