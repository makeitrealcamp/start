# == Schema Information
#
# Table name: solutions
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  challenge_id :integer
#  status       :integer
#  attempts     :integer          default("0")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class SolutionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
