require 'rails_helper'

RSpec.feature "Courses", type: :feature do
  let!(:user) { create(:paid_user) }
  let!(:admin) { create(:admin) }
  let!(:phase) { create(:phase) }
  let!(:course) { create(:course,phase: phase) }

  context 'when accessed as user' do
    scenario "list all courses published" do
      create(:course,phase: phase)
      create(:course,phase: phase)
      create(:course,phase: phase,published: false)
      login(user)
      expect(Course.where(published: true).count).to eq 3
      visit phase_path(phase)
      expect(page).to have_selector('.course', count: 3)
    end

    scenario 'should not show form new course' do
      login(user)
      expect{visit new_course_path}.to  raise_error ActionController::RoutingError
    end

    scenario 'should not show form edit course' do
      login(user)
      expect{visit edit_course_path(course)}.to  raise_error ActionController::RoutingError
    end

    scenario 'show course' do
      login(user)
      visit phase_path(phase)
      all('a', text: 'Entrar').first.click
      expect(current_path).to eq course_path(course)
    end

    scenario 'list all courses' do
      user = create(:user, account_type: User.account_types[:paid_account])
      create(:course,phase: phase)
      create(:course,phase: phase)
      login(user)
      visit phase_path(phase)
      expect(page).to have_selector('.course', count: 3)
    end
  end

  context 'when accessed as admin' do
    scenario "list all  courses published" do
      create(:course,phase: phase)
      create(:course,phase: phase)
      create(:course,phase: phase, published: false)
      login(admin)
      visit phase_path(phase)
      expect(page).to have_selector('.course', count: 4)
    end

    scenario 'display form new course' do
      login(admin)
      visit phase_path(phase)
      click_link 'Nuevo Curso'
      expect(current_path).to eq new_course_path
    end

    scenario 'create course with valid input' do
      login(admin)
      visit phase_path(phase)
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

    scenario 'create course without valid input' do
      login(admin)
      visit phase_path(phase)
      click_link 'Nuevo Curso'

      expect {
        fill_in 'course_description', with: Faker::Lorem.sentence
        fill_in 'course_excerpt', with: Faker::Lorem.paragraph
        fill_in 'course_time_estimate', with: "#{Faker::Number.digit} horas"
        click_button 'Crear Course'
      }.not_to change(Course, :count)

      expect(page).to have_selector ".alert-error"
    end

    scenario 'edit course with valid input' do
      course = create(:course,phase: phase)
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

    scenario 'edit course without valid input' do
      course = create(:course)
      login(admin)
      visit edit_course_path(course)

      description = Faker::Lorem.sentence
      excerpt = Faker::Lorem.paragraph
      time_estimate = "#{Faker::Number.digit} horas"

      fill_in 'course_name', with: nil
      fill_in 'course_description', with: description
      fill_in 'course_excerpt', with: excerpt
      fill_in 'course_time_estimate', with: time_estimate
      click_button 'Actualizar Course'
      expect(page).to have_selector ".alert-error"
    end
  end
end
