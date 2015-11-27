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
    context 'create badge' do
      context 'when giving method is points', js: true do
        scenario 'with valid input' do
          login(admin)
          wait_for_ajax
          visit admin_badges_path
          click_link  'Nueva insignia'
          name = Faker::Name::name
          description = Faker::Lorem.paragraph
          image_url =  Faker::Avatar.image
          required_points = 100
          expect {
            fill_in 'badge_name', with: name
            fill_in 'badge_description', with: description
            fill_in 'badge_image_url', with: image_url
            select 'Points', from: "badge_giving_method"
            fill_in 'badge_required_points', with: required_points
            select course.name, from: "badge_course_id"
            click_button 'Crear insignia'
          }.to change(Badge, :count).by 1
          badge  = Badge.last
          expect(badge).not_to be nil
          expect(badge.name).to eq name
          expect(badge.description).to eq description
          expect(badge.image_url).to eq image_url
          expect(badge.giving_method).to eq "points"
          expect(badge.required_points).to eq required_points
          expect(Badge.count).to eq 2
          expect(badge.course).to eq course
          expect(current_path).to eq admin_badges_path
        end

        scenario 'without valid input' do
          login(admin)
          wait_for_ajax
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

          expect(page).to have_selector '.alert-error'
        end
      end

      context 'when giving method is manually', js: true do
        scenario 'with valid input' do
          login(admin)
          wait_for_ajax
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
          expect(badge.required_points).to be_nil
          expect(Badge.count).to eq 2
          expect(badge.course).to be_nil
          expect(current_path).to eq admin_badges_path
        end

        scenario 'without valid input', js: true do
          login(admin)
          wait_for_ajax
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

    context 'edit badge' do
      context 'when giving method is points', js: true do
        scenario 'with valid input' do
          badge = create(:badge, giving_method: "points", required_points: 100, course: course)
          login(admin)
          wait_for_ajax
          visit admin_badges_path
          all(:css, '.badges .glyphicon.glyphicon-pencil').last.click
          name = Faker::Name::name
          description = Faker::Lorem.paragraph
          image_url =  Faker::Avatar.image
          required_points = 100
          fill_in 'badge_name', with: name
          fill_in 'badge_description', with: description
          fill_in 'badge_image_url', with: image_url
          fill_in 'badge_required_points', with: required_points
          select course.name, from: "badge_course_id"
          click_button 'Actualizar insignia'
          badge.reload
          expect(badge.name).to eq name
          expect(badge.description).to eq description
          expect(badge.image_url).to eq image_url
          expect(current_path).to eq  admin_badges_path
        end

        scenario 'without valid input' do
          badge = create(:badge, giving_method: "points", required_points: 100, course: course)
          login(admin)
          wait_for_ajax
          visit admin_badges_path
          all(:css, '.badges .glyphicon.glyphicon-pencil').last.click
          name = Faker::Name::name
          description = Faker::Lorem.paragraph
          image_url =  Faker::Avatar.image
          required_points = 100
          fill_in 'badge_name', with: name
          fill_in 'badge_description', with: description
          fill_in 'badge_image_url', with: image_url
          fill_in 'badge_required_points', with: ""
          click_button 'Actualizar insignia'
          expect(page).to have_selector '.alert-error'
        end
      end

      context 'when giving method is manually', js: true do

        scenario 'with valid input' do
          login(admin)
          wait_for_ajax
          visit admin_badges_path
          all(:css, '.badges .glyphicon.glyphicon-pencil').first.click
          name = Faker::Name::name
          description = Faker::Lorem.paragraph
          image_url =  Faker::Avatar.image
          required_points = 100
          fill_in 'badge_name', with: name
          fill_in 'badge_description', with: description
          fill_in 'badge_image_url', with: image_url
          click_button 'Actualizar insignia'
          badge.reload
          expect(badge.name).to eq name
          expect(badge.description).to eq description
          expect(badge.image_url).to eq image_url
          expect(current_path).to eq admin_badges_path
        end

        scenario 'without valid input' do
          login(admin)
          wait_for_ajax
          visit admin_badges_path
          all(:css, '.badges .glyphicon.glyphicon-pencil').last.click
          fill_in 'badge_name', with: ""
          fill_in 'badge_description', with: ""
          fill_in 'badge_image_url', with: ""
          click_button 'Actualizar insignia'
          expect(page).to have_selector '.alert-error'
        end
      end
    end

    scenario 'delete badge', js: true do
      create(:badge)
      login(admin)
      wait_for_ajax
      visit admin_badges_path
      all(:css, '.badges .glyphicon.glyphicon-remove').last.click
      page.driver.browser.switch_to.alert.accept
      wait_for_ajax
      expect(Badge.count).to eq 1
      expect(page).to have_selector('table.badges tbody tr', count: 1)
    end

  end
end
