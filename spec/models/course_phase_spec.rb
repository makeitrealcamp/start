# == Schema Information
#
# Table name: course_phases
#
#  id         :integer          not null, primary key
#  subject_id :integer
#  phase_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe CoursePhase, type: :model do
  context 'associations' do
    it { should belong_to(:subject) }
    it { should belong_to(:phase) }
  end

  context 'validations' do
    it { should validate_presence_of :subject }
    it { should validate_presence_of :phase }
  end

  it "has a valid factory" do
    expect(build(:course_phase)).to be_valid
  end
end
