require 'rails_helper'

RSpec.feature "Lessons", type: :feature do
  scenario "shows lesson", js: true do
    user = create(:user_with_path)
    course = create(:course_with_phase)
    resource = create(:resource, type: "course", course: course)
    section = create(:section, resource: resource)
    lesson = create(:lesson, section: section, description: "Hello World")

    login(user)

    click_link "Temas"
    all(:css, ".course").first.click
    find(:css, "#resources").click
    click_link resource.title, match: :first
    click_link lesson.name, match: :first

    expect(page).to have_content "Hello World"
  end

end