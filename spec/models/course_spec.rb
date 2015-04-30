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
  end

  context 'validations' do
    it { should validate_presence_of :name }
  end


  it "has a valid factory" do
    expect(build(:course)).to be_valid
  end
end
