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

  describe "user notifications" do

    let!(:course)    { create(:course) }
    let!(:challenge) { create(:challenge, course: course, published: true, restricted: true) }
    let!(:level_1)  {create(:level_1)}
    let!(:level_2)  {create(:level_2)}
    let!(:user) { create(:user, level: level_1) }
    let!(:other_user) { create(:user) }

    context "user goes from level_1 to level_2" do
      it "should notify user after level up" do
        original_count = user.notifications.unread.level_up.count
        user.level = level_2
        user.save
        expect(user.notifications.unread.level_up.count).to eq(original_count + 1)
        expect(user.notifications.unread.level_up.where("data->>'level_id' = ?",level_2.id.to_s).count).to eq(1)
      end
    end

    context "user earns point" do
      it "should notify user after he receives points" do
        original_count = user.notifications.unread.points_earned.count
        point = Point.create!(user: user, course: course, points: challenge.point_value, pointable: challenge)
        expect(user.notifications.unread.points_earned.count).to eq(original_count + 1)
        expect(user.notifications.unread.points_earned.where("data->>'point_id' = ?",point.id.to_s).count).to eq(1)
      end
    end

    context "user publish a comment in challenge discussion" do
      let!(:comment) { create(:comment,commentable: challenge, user: user) }

      context "other user comments in a commentable commented by the user" do
        it "should notify user about activity in the commentable" do
          other_comment = create(:comment, commentable: challenge, user: other_user)
          expect(user.notifications.unread.comment_activity.where("data->>'comment_id' = ?",other_comment.id.to_s).count).to eq(1)
        end
      end

      context "user comments in a commentable commented by the same user" do
        it "should not notify user about activity in the commentable" do
          other_comment = create(:comment, commentable: challenge, user: user)
          expect(user.notifications.unread.comment_activity.where("data->>'comment_id' = ?",other_comment.id.to_s).count).to eq(0)
        end
      end

      context "other user replies to a user's comment" do
        it "should notify user about comment reply" do
          response = create(:comment, commentable: challenge, user: other_user, response_to: comment)
          expect(user.notifications.unread.comment_response.where("data->>'response_id' = ?",response.id.to_s).count).to eq(1)
        end
      end

      context "user replies to a comment published by himself" do
        it "should not notify user about comment reply" do
          response = create(:comment, commentable: challenge, user: user, response_to: comment)
          expect(user.notifications.unread.comment_response.where("data->>'response_id' = ?",response.id.to_s).count).to eq(0)
        end
      end
    end
  end
end
