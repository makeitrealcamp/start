# == Schema Information
#
# Table name: phases
#
#  id          :integer          not null, primary key
#  number      :integer
#  name        :string
#  description :text
#  slug        :string
#  row         :integer
#  published   :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :phase do
    number 1
name "MyString"
description "MyText"
  end

end
