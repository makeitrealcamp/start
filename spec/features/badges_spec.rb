require 'rails_helper'

RSpec.feature "Badges", type: :feature do

  let!(:user)      { create(:user) }
  let!(:admin )    { create(:admin) }
  let!(:course)    { create(:course) }
  let!(:badge)     { create(:badge) }

  context 'when user is not admin' do
    scenario 'should not allow access' do
      login(user)
      expect { visit admin_badges_path }.to raise_error ActionController::RoutingError
    end
  end

  context 'when user is  admin' do
    scenario "show list baddges", js: true do
      login(admin)
      sleep(1.0)
      visit admin_badges_path
      expect(current_path).to eq admin_badges_path
    end

    scenario 'display form new badge' do
      login(admin)
      sleep(1.0)
      visit admin_badges_path
      click_link  'Nueva insignia'
      sleep(1.0)
      expect(current_path).to eq new_admin_badge_path
    end

    #FIXME test A is broken
    context 'when create badge' do
      scenario 'with valid input', js: true do
        login(admin)
        sleep(1.0)
        visit admin_badges_path
        click_link  'Nueva insignia'
        sleep(1.0)
        name = Faker::Name::name
        description = Faker::Lorem.paragraph
        image_url =  Faker::Avatar.image
        expect {
          fill_in 'badge_name', with: name
          fill_in 'badge_description', with: description
          select course.name, from: "badge_course_id"
          fill_in 'badge_require_points', with: "100"
          click_button 'Crear insignia'
        }.to change(Badge, :count).by 1

        badge  = User.last
        expect(badge).not_to be nil
        expect(badge.name).to eq name
        expect(badge.description).to eq description
        expect(badge.course).to eq course
        expect(current_path).to eq admin_badges_path
      end

      scenario 'without valid input', js: true do
        login(admin)
        sleep(1.0)
        visit admin_badges_path
        click_link  'Nueva insignia'
        sleep(1.0)
        expect {
          click_button 'Crear insignia'
        }.not_to change(Course, :count)

        expect(page).to have_selector ".panel-danger"
      end
    end
  end
end
