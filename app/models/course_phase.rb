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

class CoursePhase < ApplicationRecord
  belongs_to :phase
  belongs_to :subject

  validates :phase, presence: true
  validates :subject, presence: true
end
