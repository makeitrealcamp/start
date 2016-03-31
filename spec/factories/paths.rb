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
    published true

    factory :path_with_phases do
      after(:create) { |path| 3.times { create(:phase, path: path, published: true) } }
    end
  end

end
