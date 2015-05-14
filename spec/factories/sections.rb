# == Schema Information
#
# Table name: sections
#
#  id          :integer          not null, primary key
#  resource_id :integer
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  row         :integer
#

FactoryGirl.define do
  factory :section do
    resource { create(:resource,type: :course) }
    title { Faker::Name.title }
  end

end
