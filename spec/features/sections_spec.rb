require 'rails_helper'

RSpec.feature "Sections", type: :feature do

  let!(:user) { create(:user) }
  let!(:admin) { create(:admin) }
  let!(:course) { create(:course) }
  let!(:resource) { create(:resource, type: "course", content: Faker::Lorem.paragraph, course: course) }
  let!(:section) { create(:section, resource: resource) }
  let!(:lesson) { create(:lesson, section: section) }

  context 'when accessed as admin' do
    scenario 'delete lesson', js: true do
      login(admin)
      visit course_resource_path(course, resource)
      all(:css, '.resource-section-title a .glyphicon.glyphicon-remove').first.click
      page.driver.browser.switch_to.alert.accept
      wait_for_ajax
      expect(resource.sections.count).to eq 0
      expect(Lesson.count).to eq 0
      expect(page).to have_selector('.sections .lessons', count: 0)
    end

    context 'when edit Section', js: true do
      scenario 'display form'  do
        login(admin)
        visit course_resource_path(course, resource)
        all(:css, '.resource-section-title a .glyphicon.glyphicon-pencil').first.click
        sleep(1.0)
        expect(page).to have_selector '.form-edit-section'
      end

      scenario 'when click on cancel button'  do
        login(admin)
        visit course_resource_path(course, resource)
        all(:css, '.resource-section-title a .glyphicon.glyphicon-pencil').first.click
        click_button 'Cancelar'
        sleep(1.0)
        expect(page).not_to have_selector '.form-edit-section'
      end

      scenario 'update section with valid input'  do
        login(admin)
        visit course_resource_path(course, resource)
        all(:css, '.resource-section-title a .glyphicon.glyphicon-pencil').first.click
        title = Faker::Lorem.word
        find(:css, '.form-edit-section input#title').set(title)
        click_button 'Guardar'
        wait_for_ajax
        section.reload
        expect(section.title).to eq title
        expect(page).not_to have_selector '.form-edit-section'
      end

       scenario 'update section without valid input'  do
        login(admin)
        visit course_resource_path(course, resource)
        all(:css, '.resource-section-title a .glyphicon.glyphicon-pencil').first.click
        find(:css, '.form-edit-section input#title').set('')
        click_button 'Guardar'
        wait_for_ajax
        expect(page).to have_selector '.form-edit-section'
      end
    end
  end
end
