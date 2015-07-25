# == Schema Information
#
# Table name: badges
#
#  id             :integer          not null, primary key
#  name           :string
#  description    :text
#  require_points :integer
#  image_url      :string
#  course_id      :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  giving_method  :integer
#

require 'rails_helper'

RSpec.describe Badge, type: :model do

  context 'associations' do
    it { should belong_to(:course) }
    it { should have_many(:badges_users).dependent(:destroy) }
  end

  context 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :image_url }
    it { should validate_presence_of :giving_method }
  end

  context "has a valid factory " do
    it 'when giving method is points' do
      badge = build(:badge, giving_method: 1, require_points: 100)
      expect(badge.giving_method).to eq "points"
      expect(badge).to be_valid
    end

    it 'when giving method is manually' do
      badge = build(:badge, giving_method: 0, course: nil)
      expect(badge.giving_method).to eq "manually"
      expect(badge).to be_valid
    end
  end
end
