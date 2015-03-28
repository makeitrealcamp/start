# == Schema Information
#
# Table name: solutions
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  challenge_id  :integer
#  status        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  attempts      :integer
#  error_message :string
#  completed_at  :datetime
#

require 'rails_helper'

RSpec.describe Solution, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
