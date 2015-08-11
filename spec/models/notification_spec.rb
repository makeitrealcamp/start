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

require 'rails_helper'

RSpec.describe Notification, type: :model do

  let!(:user) { create(:user) }
  let!(:user) { create(:user) }


  describe "notification_types" do
    it "should exist a partial per each notification_type" do
      Notification.notification_types.keys.each do |notification_type|
        path = "app/views/notifications/_notification_#{notification_type}.html.erb"
        expect(File).to(
          exist("#{Rails.root}/#{path}"),
          "expected partial '#{path}' to exist"
        )
      end
    end
  end

end
