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

FactoryGirl.define do
  factory :course_phase do
    subject { create(:subject, phases: []) }
    phase { create(:phase, course_phases: []) }
  end

end
