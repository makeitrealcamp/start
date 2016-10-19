# == Schema Information
#
# Table name: subjects
#
#  id            :integer          not null, primary key
#  name          :string(50)
#  row           :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  time_estimate :string(50)
#  excerpt       :string
#  description   :string
#  slug          :string
#  published     :boolean
#

FactoryGirl.define do
  factory :subject do
    name { Faker::Name.title }
    excerpt { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    published true

    factory :subject_with_phase do
      after(:create) do |subject|
        path = Path.published.first || create(:path)
        subject.course_phases.create(phase: Phase.published.first || create(:phase, path: path, published: true))
      end
    end
  end
end
