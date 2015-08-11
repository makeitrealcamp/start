# == Schema Information
#
# Table name: notifications
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  status            :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  notification_type :integer
#  data              :json
#
# Indexes
#
#  index_notifications_on_user_id  (user_id)
#

FactoryGirl.define do
  factory :notification do
    user nil
message "MyText"
status 1
  end

end
