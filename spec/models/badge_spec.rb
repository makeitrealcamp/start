# == Schema Information
#
# Table name: badges
#
#  id              :integer          not null, primary key
#  name            :string
#  description     :text
#  required_points :integer
#  image_url       :string
#  subject_id      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  giving_method   :integer
#

require 'rails_helper'

RSpec.describe Badge, type: :model do
  context 'associations' do
    it { should belong_to(:subject) }
    it { should have_many(:badge_ownerships).dependent(:destroy) }
  end

  context 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :image_url }
    it { should validate_presence_of :giving_method }
  end

  it "has a valid factory" do
    expect(build(:badge)).to be_valid
  end
end
