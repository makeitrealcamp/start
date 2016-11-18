require 'rails_helper'

RSpec.feature "Lessons", type: :feature do
  scenario "shows lesson", js: true do
    user = create(:user_with_path)
    subject = create(:subject_with_phase)
    resource = create(:video_course, subject: subject)
    section = create(:section, resource: resource)
    lesson = create(:lesson, section: section, description: "Hello World")

    login(user)

    click_link "Temas"
    expect(page).to have_content subject.name
    all(:css, ".course").first.click
    expect(page).to have_content resource.title
    find(:css, "#resources").click
    click_link resource.title, match: :first
    click_link lesson.name, match: :first

    expect(page).to have_content "Hello World"
  end

end
