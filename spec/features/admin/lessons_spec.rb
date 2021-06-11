require 'rails_helper'

RSpec.feature "Admin lesson management", type: :feature do
  let(:admin) { create(:admin_user) }
  let(:subject) { create(:subject) }
  let(:resource) { create(:video_course, content: Faker::Lorem.paragraph, subject: subject) }
  let(:section) { create(:section, resource: resource) }

  scenario "creates a lesson" do
    login(admin)

    visit new_subject_resource_section_lesson_path(subject, resource, section)

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

    expect(page).to have_selector('.lesson')
    expect(current_path).to eq subject_resource_path(subject, resource)
  end

  scenario "updates a lesson" do
    lesson = create(:lesson, section: section)

    login(admin)

    visit edit_subject_resource_section_lesson_path(subject, resource, section, lesson)

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
    expect(current_path).to eq subject_resource_path(subject, resource)
  end

  scenario "delete lesson", js: true do
    create(:lesson, section: section)

    login(admin)

    visit subject_resource_path(subject, resource)
    all(:css, '.lessons .actions a .glyphicon.glyphicon-remove').first.click
    page.driver.browser.switch_to.alert.accept

    expect(page).to_not have_selector('.lesson')
    expect(Lesson.count).to eq 0
  end
end
