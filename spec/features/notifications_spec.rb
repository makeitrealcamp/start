require 'rails_helper'

RSpec.feature "Notifications", type: :feature do
  let!(:user) { create(:paid_user) }

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

end


def mock_notifications_service(page)
  allow(User::NOTIFICATION_SERVICE).to receive(:trigger) do |channel, event, data|
    page.execute_script("Dispatcher.trigger('#{event}',#{data.to_json});");
  end
end
