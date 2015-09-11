# == Schema Information
#
# Table name: quizzes
#
#  id         :integer          not null, primary key
#  name       :string
#  row        :integer
#  slug       :string
#  course_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_quizzes_on_course_id  (course_id)
#

class Quiz::Quiz < ActiveRecord::Base
  belongs_to :course
  has_many :questions
end
