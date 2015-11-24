# == Schema Information
#
# Table name: paths
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  published   :boolean          default(FALSE)
#

FactoryGirl.define do
  factory :path do
    name { Faker::Name.title }
    description { Faker::Hacker.say_something_smart }
    phases { create_list(:phase,3, path: nil) }
  end

end
