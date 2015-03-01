# == Schema Information
#
# Table name: documents
#
#  id          :integer          not null, primary key
#  folder_id   :integer
#  folder_type :string
#  name        :string(50)
#  content     :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class DocumentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
