require 'rails_helper'

RSpec.feature "Notifications", type: :feature do
  let!(:user) { create(:user) }

  before do
    Notification::RETRIEVE_INTERVAL_IN_MILLIS = 100
  end

  scenario "User receives 2 notifications", js: true do
    login(user)
    message1 = Faker::Lorem.sentence
    message2 = Faker::Lorem.sentence
    user.notifications.create!(notification_type: Notification.notification_types[:notice],data:{message: message1})
    find(:css,".notifications-btn").click
    within :css,"#notifications" do
      expect(page).to have_css('.notification.notification-notice')
      expect(page).to have_content(message1)
    end
    user.notifications.create!(notification_type: Notification.notification_types[:notice],data:{message: message2})
    within :css,"#notifications" do
      expect(page).to have_content(message2)
    end
  end

  context "User has a lot of notifications" do
    before do
      create_list(:notification,Notification::PER_PAGE*3, user: user )
    end
    scenario "user requests all the notifications", js: true do
      login(user)
      find(:css,".notifications-btn").click
      expect(page).to have_selector('.notification', count: Notification::PER_PAGE)
      within :css,"#notifications" do
        find(:css,".see-more-notifications a").click
        wait_for_ajax
        expect(page).to have_selector('.notification', count: Notification::PER_PAGE*2)
        find(:css,".see-more-notifications a").click
        wait_for_ajax
        expect(page).to have_selector('.notification', count: Notification::PER_PAGE*3)
        find(:css,".see-more-notifications a").click
        wait_for_ajax
        expect(page).to have_selector('.notification', count: Notification::PER_PAGE*3)
        expect(page).to have_selector('.no-more-notifications')
      end
    end

  end

end
