require 'rails_helper'

RSpec.feature "Notifications", type: :feature do
  let!(:user) { create(:paid_user) }
  let!(:course) { create(:course) }
  let!(:challenge) { create(:challenge, course: course) }
  let!(:solution) { create(:solution, user: user, challenge: challenge, status: :completed, completed_at: 1.week.ago) }


  scenario "User receives 2 notifications", js: true do
    mock_notifications_service(page)
    login(user)
    message1 = Faker::Lorem.sentence
    message2 = Faker::Lorem.sentence


    user.notifications.create!(notification_type: Notification.notification_types[:notice],data:{message: message1})
    find(:css,".notifications-btn").click
    within :css,"#notifications" do
      expect(page).to have_selector('.notification', count: user.notifications.count)
      expect(page).to have_content(message1)
    end
    user.notifications.create!(notification_type: Notification.notification_types[:notice],data:{message: message2})
    within :css,"#notifications" do
      expect(page).to have_selector('.notification', count: user.notifications.count)
      expect(page).to have_content(message2)
    end
  end

  context "User has 30 notifications" do
    before do
      create_list(:notification,(Notification::PER_PAGE*3) - user.notifications.count, user: user )
    end
    scenario "user requests all the notifications", js: true do
      mock_notifications_service(page)
      login(user)
      find(:css,".notifications-btn").click
      expect(page).to have_selector('.notification', count: Notification::PER_PAGE)
      within :css,"#notifications" do
        find(:css,".see-more-notifications a").click
        expect(page).to have_selector('.notification', count: Notification::PER_PAGE*2)
        find(:css,".see-more-notifications a").click
        expect(page).to have_selector('.notification', count: Notification::PER_PAGE*3)
        find(:css,".see-more-notifications a").click
        expect(page).to have_selector('.notification', count: Notification::PER_PAGE*3)
        expect(page).to have_selector('.no-more-notifications')
      end
    end
  end

  context 'resource is not available' do
    scenario "when notification type is comment_activity", js: true do
      mock_notifications_service(page)
      login(user)
      user.notifications.create!(notification_type: Notification.notification_types[:comment_activity], data: { comment_id: 0 })
      find(:css,".notifications-btn").click
      within :css,"#notifications" do
        expect(page).to have_selector('.notification', count: user.notifications.count)
        expect(page).to have_content("El recurso ya no se encuentra disponible")
      end
    end

    scenario "when notification type is comment_response", js: true do
      mock_notifications_service(page)
      login(user)

      user.notifications.create!(notification_type: Notification.notification_types[:comment_response], data: { response_id: 0 })
      find(:css,".notifications-btn").click
      within :css,"#notifications" do
        expect(page).to have_selector('.notification', count: user.notifications.count)
        expect(page).to have_content("El recurso ya no se encuentra disponible")
      end
    end

    scenario "when notification type is badge_earned", js: true do
      mock_notifications_service(page)
      login(user)

      user.notifications.create!(notification_type: Notification.notification_types[:badge_earned], data: { badge_id: 0 })
      find(:css,".notifications-btn").click
      within :css,"#notifications" do
        expect(page).to have_selector('.notification', count: user.notifications.count)
        expect(page).to have_content("El recurso ya no se encuentra disponible")
      end
    end
  end

  context 'when there is a notification about a comment in a challenge', js: true do
    scenario 'the notification redirects to the discussion of the challenge' do
      user1 = create(:user)
      mock_notifications_service(page)
      login(user)
      comment = create(:comment, user: user, commentable: challenge)
      user.notifications.create!(notification_type: Notification.notification_types[:comment_activity], data: { comment_id: comment.id })

      find(:css, ".notifications-btn").click
      all(".comment-link").first.click
      expect(current_path).to eq discussion_course_challenge_path(course, challenge)
    end
  end
end


def mock_notifications_service(page)
  allow(User::NOTIFICATION_SERVICE).to receive(:trigger) do |channel, event, data|
    page.execute_script("Dispatcher.trigger('#{event}',#{data.to_json});");
  end
end
