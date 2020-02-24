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
#  color       :string
#  path_id     :integer
#
# Indexes
#
#  index_phases_on_path_id  (path_id)
#

FactoryGirl.define do
  factory :phase do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence }
    color "#FF0000"
    published true
    path

    factory :phase_with_subjects do
      after(:create) { |phase| create_list(:course_phase, 3, phase: phase) }
    end
  end

end
