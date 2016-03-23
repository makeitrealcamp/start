# == Schema Information
#
# Table name: levels
#
#  id              :integer          not null, primary key
#  name            :string
#  required_points :integer
#  image_url       :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe Level, type: :model do
  context 'associations' do
    it { should have_many(:users) }
  end

  context 'validations' do
    it { should validate_presence_of :name }
  end

  it "has a valid factory" do
    expect(build(:level)).to be_valid
  end

  describe "default scope" do
    it "orders by required_points" do
      level_2 = create(:level, required_points: 200)
      level_0 = create(:level, required_points: 0)
      level_1 = create(:level, required_points: 100)

      expect(Level.all).to eq([level_0, level_1, level_2])
    end
  end

  describe ".for_points" do
    it "returns the correct level" do
      levels = [
        create(:level, required_points: 0),
        create(:level, required_points: 100),
        create(:level, required_points: 200)
      ]
      
      # level 0 - 0 to 99 points
      expect(Level.for_points(0)).to eq(levels[0])
      expect(Level.for_points(99)).to eq(levels[0])

      # level 1 - 100 to 199 points
      expect(Level.for_points(100)).to eq(levels[1])
      expect(Level.for_points(199)).to eq(levels[1])

      # level 2 - more than 200 points
      expect(Level.for_points(200)).to eq(levels[2])
      expect(Level.for_points(1000)).to eq(levels[2])
    end

    it "returns nil if no correct levels" do
      expect(Level.for_points(0)).to be_nil
    end
  end

  describe ".next" do
    it "returns the next level if exists" do
      levels = [
        create(:level, required_points: 0),
        create(:level, required_points: 100),
        create(:level, required_points: 200)
      ]

      expect(levels[0].next).to eq(levels[1])
      expect(levels[1].next).to eq(levels[2])
    end

    it "returns nil if there's no next level" do
      levels = [
        create(:level, required_points: 0),
        create(:level, required_points: 100),
        create(:level, required_points: 200)
      ]

      expect(levels[2].next).to be_nil
    end
  end
end
