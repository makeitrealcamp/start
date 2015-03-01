# == Schema Information
#
# Table name: courses
#
#  id         :integer          not null, primary key
#  name       :string(20)
#  row        :integer
#  abstract   :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
