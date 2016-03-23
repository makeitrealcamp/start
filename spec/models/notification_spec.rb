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
#  index_notifications_on_created_at  (created_at)
#  index_notifications_on_status      (status)
#  index_notifications_on_user_id     (user_id)
#

require 'rails_helper'

RSpec.describe Notification, type: :model do
  it { should define_enum_for :status }
  it { should define_enum_for :notification_type }

  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of :user }
    it { should validate_presence_of :status }
    it { should validate_presence_of :notification_type }
  end

  it "has a valid factory" do
    expect(build(:notification)).to be_valid
  end

  describe "#after_initialize" do
    context "without attributes" do
      let(:new_notification) { Notification.new }
      it "sets the defaults values" do
        expect(new_notification.status).to eq("unread")
        expect(new_notification.notification_type).to eq("notice")
      end
    end

    context "with attributes" do
      let(:new_notification) { Notification.new(status: :read, notification_type: :comment_response) }
      it "sets the received values" do
        expect(new_notification.status).to eq("read")
        expect(new_notification.notification_type).to eq("comment_response")
      end
    end

    context "when the notification is loaded" do
      let(:saved_notification) { create(:notification, status: :unread, notification_type: :level_up) }
      it "sets the correct attributes" do
        saved_notification.reload
        expect(saved_notification.status).to eq("unread")
        expect(saved_notification.notification_type).to eq("level_up")
      end
    end
  end

  describe "notification types" do
    it "exists a partial per each notification_type" do
      Notification.notification_types.keys.each do |notification_type|
        path = "app/views/notifications/_notification_#{notification_type}.html.erb"
        expect(File).to(exist("#{Rails.root}/#{path}"),
          "expected partial '#{path}' to exist")
      end
    end
  end
end
