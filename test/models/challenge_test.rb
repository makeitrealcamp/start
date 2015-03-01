# == Schema Information
#
# Table name: challenges
#
#  id           :integer          not null, primary key
#  course_id    :integer
#  name         :string(100)
#  instructions :text
#  evaluation   :text
#  row          :integer
#  published    :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class ChallengeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
