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
      visit admin_badges_path
      expect(current_path).to eq admin_badges_path
    end

    scenario 'display form new badge' do
      login(admin)
      visit admin_badges_path
      click_link  'Nueva insignia'
      expect(current_path).to eq new_admin_badge_path
    end

    context 'create badge' do
      context 'when giving method is points' do
        scenario 'with valid input', js: true do
          login(admin)
          visit admin_badges_path
          click_link  'Nueva insignia'
          name = Faker::Name::name
          description = Faker::Lorem.paragraph
          image_url =  Faker::Avatar.image
          require_points = 100
          expect {
            fill_in 'badge_name', with: name
            fill_in 'badge_description', with: description
            fill_in 'badge_image_url', with: image_url
            select 'Points', from: "badge_giving_method"
            fill_in 'badge_require_points', with: require_points
            select course.name, from: "badge_course_id"
            click_button 'Crear insignia'
          }.to change(Badge, :count).by 1
          badge  = Badge.last
          expect(badge).not_to be nil
          expect(badge.name).to eq name
          expect(badge.description).to eq description
          expect(badge.image_url).to eq image_url
          expect(badge.giving_method).to eq "points"
          expect(badge.require_points).to eq require_points
          expect(badge.course).to eq course
          expect(current_path).to eq admin_badges_path
        end

        scenario 'without valid input', js: true do
          login(admin)
          visit admin_badges_path
          click_link  'Nueva insignia'
          name = Faker::Name::name
          description = Faker::Lorem.paragraph
          image_url =  Faker::Avatar.image

          expect {
            fill_in 'badge_name', with: name
            fill_in 'badge_description', with: description
            fill_in 'badge_image_url', with: image_url
            select 'Points', from: "badge_giving_method"
            click_button 'Crear insignia'
          }.not_to change(Badge, :count)

          expect(page).to have_selector '.panel-danger'

        end
      end

      context 'when giving method is manually' do
        scenario 'with valid input', js: true do
          login(admin)
          visit admin_badges_path
          click_link  'Nueva insignia'
          name = Faker::Name::name
          description = Faker::Lorem.paragraph
          image_url =  Faker::Avatar.image
          expect {
            fill_in 'badge_name', with: name
            fill_in 'badge_description', with: description
            fill_in 'badge_image_url', with: image_url
            select 'Manually', from: "badge_giving_method"
            click_button 'Crear insignia'
          }.to change(Badge, :count).by 1
          badge  = Badge.last
          expect(badge).not_to be nil
          expect(badge.name).to eq name
          expect(badge.description).to eq description
          expect(badge.image_url).to eq image_url
          expect(badge.giving_method).to eq "manually"
          expect(badge.require_points).to be_nil
          expect(badge.course).to be_nil
          expect(current_path).to eq admin_badges_path
        end

        scenario 'without valid input', js: true do
          login(admin)
          visit admin_badges_path
          click_link  'Nueva insignia'
          name = Faker::Name::name
          description = Faker::Lorem.paragraph
          image_url =  Faker::Avatar.image
          expect {
            select 'Manually', from: "badge_giving_method"
            click_button 'Crear insignia'
          }.not_to change(Badge, :count)
          expect(current_path).to eq admin_badges_path
        end
      end
    end
  end
end
