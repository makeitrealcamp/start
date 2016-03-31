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

class CoursePhase < ActiveRecord::Base
  belongs_to :phase
  belongs_to :course

  validates :phase, presence: true
  validates :course, presence: true
end
