# == Schema Information
#
# Table name: courses
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

require 'rails_helper'

RSpec.describe Course, type: :model do

  context 'associations' do
    it { should have_many(:resources) }
    it { should have_many(:challenges) }
    it { should have_many(:badges).dependent(:destroy) }
  end

  context 'validations' do
    it { should validate_presence_of :name }
  end

  it "has a valid factory" do
    expect(build(:course)).to be_valid
  end

  context "friendly_id" do
    it "should update the slug after updating the name" do
      course = create(:course)

      # change the name of the course
      course.name = "a random name"
      course.save

      expect(course.slug).to eq("a-random-name")
      expect(course.slug).to eq(course.friendly_id)
    end
  end
end
