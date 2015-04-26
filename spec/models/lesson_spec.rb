# == Schema Information
#
# Table name: lessons
#
#  id          :integer          not null, primary key
#  section_id  :integer
#  name        :string
#  video_url   :string
#  description :text
#  row         :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Lesson, type: :model do
  context 'associations' do
    it { should belong_to(:section) }
    it { should have_many(:comments) }
  end

  context 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :section }
    it { should validate_presence_of :video_url }
    it { should_not allow_value("pepe perez").for(:video_url) }
  end

  it "has a valid factory" do
    expect(build(:lesson)).to be_valid
  end
end
