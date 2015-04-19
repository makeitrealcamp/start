require 'rails_helper'

RSpec.feature "Resource completion", type: :feature do
  let!(:user) { create(:user) }

  context "when user completes a resource but there are more resources" do
    scenario "should be redirected to next resource" do
      course = create(:course)
      resource = create(:resource, course: course)
      next_resource = create(:resource, course: course, row_position: :last)

      login(user)

      visit course_resource_path(course, resource)
      click_link 'Completar y Continuar'
      expect(current_path).to eq course_resource_path(course, next_resource)
    end
  end

  context "when user completes last resource but haven`t finished course" do
    scenario "should be redirected to same course" do
      course = create(:course)
      resource = create(:resource, course: course)
      challenge = create(:challenge, course: course)

      login(user)

      visit course_resource_path(resource.course, resource)
      click_link 'Completar y Continuar'
      expect(current_path).to eq course_path(resource.course)     
    end
  end

  context "when a user completes course and there are more courses" do
    scenario "should be redirected to next course" do
      resource = create(:resource)
      next_course = create(:course, row_position: :last)

      login(user)

      visit course_resource_path(resource.course, resource)
      click_link 'Completar y Continuar'
      expect(current_path).to eq course_path(next_course)     
    end
  end

  context "when a user completes course and there are no more courses" do
    scenario "should be redirected to same course" do
      resource = create(:resource)

      login(user)

      visit course_resource_path(resource.course, resource)
      click_link 'Completar y Continuar'
      expect(current_path).to eq course_path(resource.course)     
    end
  end
end