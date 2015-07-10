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

FactoryGirl.define do
  factory :pair_programming_time do
    user nil
day 1
start_time "2015-07-08 17:56:10"
end_time "2015-07-08 17:56:10"
time_zone "MyString"
  end

end
