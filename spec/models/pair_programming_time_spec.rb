# == Schema Information
#
# Table name: pair_programming_times
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  day                 :integer
#  start_time_hour     :integer
#  start_time_minute   :integer
#  time_zone           :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  duration_in_minutes :integer
#
# Indexes
#
#  index_pair_programming_times_on_user_id  (user_id)
#

require 'rails_helper'

RSpec.describe PairProgrammingTime, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
