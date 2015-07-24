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
    it { should validate_presence_of :require_points }
    it { should validate_presence_of :course }
  end

  it "has a valid factory" do
    expect(build(:badge)).to be_valid
  end
end
