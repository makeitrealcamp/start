# == Schema Information
#
# Table name: course_phases
#
#  id         :integer          not null, primary key
#  course_id  :integer
#  phase_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :course_phase do
    course { create(:course, phases: []) }
    phase { create(:phase,course_phases: []) }
  end

end
