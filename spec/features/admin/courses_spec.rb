require 'rails_helper'

RSpec.describe "Courses management" do
  let(:admin) { create(:admin) }
  let(:path) { user.paths.published.first }
  let(:phase) { path.phases.first }

  scenario "creates a new course" do
    login(admin)
    visit admin_courses_path
    click_link 'Nuevo Curso'

    expect {
      fill_in 'course_name', with: Faker::Name::title
      fill_in 'course_description', with: Faker::Lorem.sentence
      fill_in 'course_excerpt', with: Faker::Lorem.paragraph
      fill_in 'course_time_estimate', with: "#{Faker::Number.digit} horas"
      click_button 'Crear Course'
    }.to change(Course, :count).by 1

    course = Course.last
    expect(course).not_to be_nil
    expect(current_path).to eq course_path(course)
    expect(page).to have_content "El curso ha sido creado"
  end

  scenario "edits a course" do
    course = create(:course)
    
    login(admin)
    visit edit_course_path(course)
    
    name = Faker::Name::title
    description = Faker::Lorem.sentence
    excerpt = Faker::Lorem.paragraph
    time_estimate = "#{Faker::Number.digit} horas"

    fill_in 'course_name', with: name
    fill_in 'course_description', with: description
    fill_in 'course_excerpt', with: excerpt
    fill_in 'course_time_estimate', with: time_estimate
    click_button 'Actualizar Course'

    course.reload
    expect(course.name).to eq name
    expect(course.description).to eq description
    expect(course.excerpt).to eq excerpt
    expect(course.time_estimate).to eq time_estimate
    expect(page).to have_content 'El curso ha sido actualizado'
  end
end