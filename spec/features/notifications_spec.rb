require 'rails_helper'

RSpec.feature "Notifications", type: :feature do
  let(:user) { create(:user) }
  let(:subject) { create(:subject) }
  let(:challenge) { create(:challenge, subject: subject) }
  let!(:solution) { create(:solution, user: user, challenge: challenge, status: :completed, completed_at: 1.week.ago) }

  scenario "user receives two notifications", js: true do
    mock_notifications_service(page)

    login(user)

    # send a notification
    message1 = Faker::Lorem.sentence
    user.notifications.create!(notification_type: Notification.notification_types[:notice], data: { message: message1 })

    # check that notification is shown in the page
    find(:css,".notifications-btn").click
    within :css,"#notifications" do
      expect(page).to have_selector('.notification', count: user.notifications.count)
      expect(page).to have_content(message1)
    end

    # send another notification
    message2 = Faker::Lorem.sentence
    user.notifications.create!(notification_type: Notification.notification_types[:notice],data:{message: message2})

    # check that the second notification is shown in the page
    within :css,"#notifications" do
      expect(page).to have_selector('.notification', count: user.notifications.count)
      expect(page).to have_content(message2)
    end
  end

  scenario "user has three pages of notifications", js: true do
    # we need to create the notifications before mocking the notification service
    create_list(:notification, (Notification::PER_PAGE * 3) - user.notifications.count, user: user)

    mock_notifications_service(page)

    login(user)

    # show the first page
    find(:css, ".notifications-btn").click
    expect(page).to have_selector('.notification', count: Notification::PER_PAGE)
    within :css, "#notifications" do
      # show the second page
      find(:css, ".see-more-notifications a").click
      expect(page).to have_selector('.notification', count: Notification::PER_PAGE*2)

      # show the third page
      find(:css, ".see-more-notifications a").click
      expect(page).to have_selector('.notification', count: Notification::PER_PAGE*3)

      # show the fourth page
      find(:css, ".see-more-notifications a").click
      expect(page).to have_selector('.notification', count: Notification::PER_PAGE*3)
      expect(page).to have_selector('.no-more-notifications')
    end
  end

  scenario "tells the user that the resource is no longer available", js: true do
    mock_notifications_service(page)

    login(user)
    user.notifications.create!(notification_type: Notification.notification_types[:comment_activity], data: { comment_id: 0 })
    find(:css,".notifications-btn").click

    within :css,"#notifications" do
      expect(page).to have_selector('.notification', count: user.notifications.count)
      expect(page).to have_content("El recurso ya no se encuentra disponible")
    end
  end

  context 'when there is a notification about a comment in a challenge', js: true do
    scenario 'the notification redirects to the challenge' do
      user1 = create(:user)
      mock_notifications_service(page)
      login(user)

      comment = create(:comment, user: user, commentable: challenge)
      user.notifications.create!(notification_type: Notification.notification_types[:comment_activity], data: { comment_id: comment.id })

      find(:css, ".notifications-btn").click
      all(".comment-link").first.click
      wait_for { current_path }.to eq subject_challenge_path(subject, challenge)
    end
  end
end

def mock_notifications_service(page)
  allow(User::NOTIFICATION_SERVICE).to receive(:trigger) do |channel, event, data|
    page.execute_script("Dispatcher.trigger('#{event}',#{data.to_json});");
  end
end
