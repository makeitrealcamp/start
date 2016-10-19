require 'rails_helper'

RSpec.feature "Sections", type: :feature do
  let(:admin) { create(:admin) }
  let(:subject) { create(:subject) }
  let(:resource) { create(:video_course, subject: subject) }

  scenario "creates a new section", js: true do
    login(admin)

    visit subject_resource_path(subject, resource)
    click_link 'Nueva Sección'

    title = Faker::Name.title
    find(:css, '.modal-dialog input#section_title').set(title)
    click_button 'Crear Section'

    expect(page).not_to have_selector ".modal-dialog"

    section = resource.sections.last
    expect(page).to have_selector(".sections #section_#{section.id}")

    expect(section).not_to be nil
    expect(section.title).to eq title
  end

  scenario "edits a section", js: true do
    section = create(:section, resource: resource)

    login(admin)

    visit subject_resource_path(subject, resource)
    all(:css, '.resource-section-title a .glyphicon.glyphicon-pencil').first.click

    title = Faker::Name.title
    find(:css, '.modal-dialog input#section_title').set(title)
    click_button 'Actualizar Section'

    expect(page).not_to have_selector '.modal-dialog'

    section.reload
    expect(section.title).to eq title
  end

  scenario "deletes a section", js: true do
    section = create(:section, resource: resource)

    login(admin)

    visit subject_resource_path(subject, resource)
    all(:css, '.resource-section-title a .glyphicon.glyphicon-remove').first.click
    page.driver.browser.switch_to.alert.accept

    expect(page).to have_selector('.sections .lessons', count: 0)

    expect(resource.sections.count).to eq 0
    expect(Lesson.count).to eq 0
  end
end
