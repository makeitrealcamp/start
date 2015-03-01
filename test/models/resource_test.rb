# == Schema Information
#
# Table name: resources
#
#  id          :integer          not null, primary key
#  course_id   :integer
#  title       :string(100)
#  description :string
#  row         :integer
#  type        :integer
#  url         :string
#  estimated   :string(70)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class ResourceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
