require 'rails_helper'

RSpec.feature "Lessons", type: :feature do

  let!(:user) { create(:user) }
  let!(:admin) { create(:admin) }
  let!(:course) { create(:course) }
  let!(:resource) { create(:resource, type: "course", content: Faker::Lorem.paragraph, course: course) }
  let!(:section) { create(:section, resource: resource) }
  let!(:lesson) { create(:lesson, section: section) }

  context 'when accessed as user' do
    scenario 'should not allow acess to edit lessons' do
      resource = create(:resource, type: "course", content: Faker::Lorem.paragraph, course: course)
      section = create(:section, resource: resource)
      lesson = create(:lesson, section: section)
      login(user)
      expect { visit edit_lesson_path(lesson) }.to raise_error ActionController::RoutingError
    end
  end

  context 'when accessed as admin', js: true do
    scenario 'display form edit lesson' do
      login(admin)
      visit course_resource_path(course, resource)
      all(:css, '.lesson-actions a .glyphicon.glyphicon-pencil').first.click
      sleep(1.0)
      expect(current_path).to eq edit_lesson_path(lesson)
    end

    scenario 'when click on cancel button' do
      login(admin)
      visit course_resource_path(course, resource)
      all(:css, '.lesson-actions a .glyphicon.glyphicon-pencil').first.click
      sleep(1.0)
      click_link 'Cancelar'
      sleep(1.0)
      expect(current_path).to eq course_resource_path(course, resource)
    end

    scenario 'update form with valid input' do
      login(admin)
      visit edit_lesson_path(lesson)
      name = Faker::Lorem.word
      video_url = Faker::Internet.url
      description = Faker::Lorem.paragraph
      info = Faker::Lorem.paragraph

      fill_in 'lesson_name', with: name
      fill_in 'lesson_video_url', with: video_url
      fill_in 'lesson_description', with: description
      fill_in 'lesson_info', with: info
      click_button 'Actualizar Lesson'

      lesson.reload
      expect(lesson.name).to eq name
      expect(video_url).to eq video_url
      expect(description).to eq description
      expect(info).to eq info
      expect(current_path).to eq course_resource_path(course, resource)
    end

    scenario 'update form without valid input' do
      login(admin)
      visit edit_lesson_path(lesson)
      video_url = Faker::Internet.url
      description = Faker::Lorem.paragraph
      info = Faker::Lorem.paragraph

      fill_in 'lesson_name', with: nil
      fill_in 'lesson_video_url', with: video_url
      fill_in 'lesson_description', with: description
      fill_in 'lesson_info', with: info
      click_button 'Actualizar Lesson'

      expect(page).to have_selector '.panel-danger'
    end

    scenario 'delete lesson' do
      create(:lesson, section: section)
      login(admin)
      visit course_resource_path(course, resource)
      all(:css, '.lesson-actions a .glyphicon.glyphicon-remove').first.click
      page.driver.browser.switch_to.alert.accept
      wait_for_ajax
      expect(Lesson.count).to eq 1
      expect(page).to have_selector('.lesson', count: 1)
    end
  end



end
