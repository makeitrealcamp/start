# == Schema Information
#
# Table name: phases
#
#  id          :integer          not null, primary key
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
    name { Faker::Name.title }
    description { Faker::Lorem.sentence }
    color "#FF0000"
    published true
  end

end
