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
    references ""
references ""
  end

end
