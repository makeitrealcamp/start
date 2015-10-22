require 'rails_helper'

RSpec.feature "Lessons", type: :feature do

  let!(:user) { create(:paid_user) }
  let!(:admin) { create(:admin) }
  let!(:course) { create(:course) }
  let!(:resource) { create(:resource, type: "course", content: Faker::Lorem.paragraph, course: course) }
  let!(:section) { create(:section, resource: resource) }
  let!(:lesson) { create(:lesson, section: section) }

  context 'when accessed as user' do
    scenario 'should not allow acess to edit lessons' do
      login(user)
      expect {visit edit_course_resource_section_lesson_path(course, resource, section, lesson)}.to raise_error ActionController::RoutingError
    end

    scenario 'should not allow acess to create lessons' do
      login(user)
      expect {visit new_course_resource_section_lesson_path(course,resource,section)}.to raise_error ActionController::RoutingError
    end
  end

  context 'when accessed as admin', js: true do
    context 'create lesson' do
      scenario 'with valid input' do
        login(admin)
        wait_for_ajax
        visit new_course_resource_section_lesson_path(course, resource,section)
        name = Faker::Lorem.word
        video_url = Faker::Internet.url
        description = Faker::Lorem.paragraph
        info = Faker::Lorem.paragraph

        expect {
          fill_in 'lesson_name', with: name
          fill_in 'lesson_video_url', with: video_url
          fill_in 'lesson_description', with: description
          fill_in 'lesson_info', with: info
          click_button 'Crear Lesson'
        }.to change(Lesson, :count).by 1

        lesson = section.lessons.last
        expect(lesson.name).to eq name
        expect(video_url).to eq video_url
        expect(description).to eq description
        expect(info).to eq info

        expect(page).to have_selector('.lesson', count: 2)
        expect(current_path).to eq course_resource_path(course, resource)
      end

      scenario 'without valid input' do
        login(admin)
        wait_for_ajax
        visit new_course_resource_section_lesson_path(course, resource,section)
        name = Faker::Lorem.word
        video_url = Faker::Internet.url
        description = Faker::Lorem.paragraph
        info = Faker::Lorem.paragraph

        expect {
          fill_in 'lesson_name', with: nil
          fill_in 'lesson_video_url', with: 'lorem'
          fill_in 'lesson_description', with: description
          fill_in 'lesson_info', with: info
          click_button 'Crear Lesson'
        }.not_to change(Lesson, :count)

        expect(page).to have_selector '.alert-error'
        expect(current_path).to eq course_resource_section_lessons_path(course,resource,section)
      end
    end

    context 'update lesson' do
      scenario 'when click on cancel button', js: true do
        login(admin)
        wait_for_ajax
        visit edit_course_resource_section_lesson_path(course, resource,section,lesson)
        click_link 'Cancelar'
        expect(current_path).to eq course_resource_path(course, resource)
      end

      scenario 'update form with valid input', js: true do
        login(admin)
        wait_for_ajax
        visit edit_course_resource_section_lesson_path(course,resource,section,lesson)
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

      scenario 'update form without valid input', js: true do
        login(admin)
        wait_for_ajax
        visit edit_course_resource_section_lesson_path(lesson.section.resource.course,lesson.section.resource,lesson.section,lesson)
        video_url = Faker::Internet.url
        description = Faker::Lorem.paragraph
        info = Faker::Lorem.paragraph
        fill_in 'lesson_name', with: nil
        fill_in 'lesson_video_url', with: video_url
        fill_in 'lesson_description', with: description
        fill_in 'lesson_info', with: info
        click_button 'Actualizar Lesson'
        expect(page).to have_selector '.alert-error'
      end
    end

    scenario 'delete lesson', js: true do
      create(:lesson, section: section)
      login(admin)
      wait_for_ajax
      visit course_resource_path(course, resource)
      all(:css, '.lessons .actions a .glyphicon.glyphicon-remove').first.click
      page.driver.browser.switch_to.alert.accept
      wait_for_ajax
      expect(Lesson.count).to eq 1
      expect(page).to have_selector('.lesson', count: 1)
    end
  end

end
