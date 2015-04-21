# == Schema Information
#
# Table name: comments
#
#  id             :integer          not null, primary key
#  discussion_id  :integer
#  text           :text
#  response_to_id :integer
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'rails_helper'

RSpec.describe Comment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
