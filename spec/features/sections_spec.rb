require 'rails_helper'

RSpec.feature "Sections", type: :feature do

  let!(:user) { create(:user) }
  let!(:admin) { create(:admin) }
  let!(:course) { create(:course) }
  let!(:resource) { create(:resource, type: "course", content: Faker::Lorem.paragraph, course: course) }
  let!(:section) { create(:section, resource: resource) }
  let!(:lesson) { create(:lesson, section: section) }

  context 'when accessed as admin' do
    context 'new section', js: true do

      scenario 'with valid input' do
        login(admin)
        visit course_resource_path(course, resource)
        click_link 'Nueva Sección'
        wait_for_ajax
        title = Faker::Name.title
        find(:css, '.modal-dialog input#section_title').set(title)
        click_button 'Crear Section'
        wait_for_ajax
        section = resource.sections.last
        expect(section).not_to be nil
        expect(section.title).to eq title
        expect(page).not_to have_selector '.modal-dialog'
        expect(page).to have_selector('.sections .lessons', count: 2)
      end

      scenario 'without valid input' do
        login(admin)
        visit course_resource_path(course, resource)
        click_link 'Nueva Sección'
        wait_for_ajax
        click_button 'Crear Section'
        wait_for_ajax
        expect(page).to have_selector '.modal-dialog'
        expect(page).to have_selector '.alert'
        expect(page).to have_selector('.sections .lessons', count: 1)
      end
    end

    context 'edit Section', js: true do

      scenario 'with valid input'  do
        login(admin)
        visit course_resource_path(course, resource)
        all(:css, '.resource-section-title a .glyphicon.glyphicon-pencil').first.click
        wait_for_ajax
        title = Faker::Name.title
        find(:css, '.modal-dialog input#section_title').set(title)
        click_button 'Actualizar Section'
        wait_for_ajax
        section.reload
        expect(section.title).to eq title
        expect(page).not_to have_selector '.modal-dialog'
      end

      scenario 'without valid input'  do
        login(admin)
        visit course_resource_path(course, resource)
        all(:css, '.resource-section-title a .glyphicon.glyphicon-pencil').first.click
        wait_for_ajax
        find(:css, '.modal-dialog input#section_title').set('')
        click_button 'Actualizar Section'
        wait_for_ajax
        expect(page).to have_selector '.modal-dialog'
        expect(page).to have_selector '.alert'
      end
    end

    scenario 'delete section', js: true do
      login(admin)
      visit course_resource_path(course, resource)
      all(:css, '.resource-section-title a .glyphicon.glyphicon-remove').first.click
      handle_confirm
      wait_for_ajax
      expect(resource.sections.count).to eq 0
      expect(Lesson.count).to eq 0
      expect(page).to have_selector('.sections .lessons', count: 0)
    end
  end
end
