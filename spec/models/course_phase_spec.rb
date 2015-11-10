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

require 'rails_helper'

RSpec.describe CoursePhase, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
