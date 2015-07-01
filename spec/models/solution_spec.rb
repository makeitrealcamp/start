# == Schema Information
#
# Table name: solutions
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  challenge_id :integer
#  status       :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  attempts     :integer
#  properties   :hstore
#
# Indexes
#
#  index_solutions_on_challenge_id  (challenge_id)
#  index_solutions_on_user_id       (user_id)
#  solutions_gin_properties         (properties)
#

require 'rails_helper'

RSpec.describe Solution, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
