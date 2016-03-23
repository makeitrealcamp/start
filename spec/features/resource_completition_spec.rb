require 'rails_helper'

RSpec.feature "Resource completion", type: :feature do
  let!(:user) { create(:user) }
  let!(:course) { create(:course) }

  context "when user completes a resource and there are more resources", js: true do
    scenario "redirects to next resource" do
      resource = create(:resource, course: course)
      next_resource = create(:resource, course: course, row_position: :last)
      
      login(user)
      
      visit course_resource_path(course, resource)
      click_link 'Completar y Continuar'
      
      expect(current_path).to eq course_resource_path(course, next_resource)
    end
  end

  context "when user completes last resource but haven`t finished course" do
    scenario "redirects to same course", js: true do
      resource = create(:resource, course: course)
      challenge = create(:challenge, course: course)
      
      login(user)
      
      visit course_resource_path(resource.course, resource)
      click_link 'Completar y Continuar'
      
      expect(current_path).to eq course_path(resource.course)
    end
  end

  context "when user completes last resource (and course) and there are more courses" do
    scenario "redirects to next course", js: true do
      current_course = create(:course, row_position: :last)
      resource = create(:resource, course: current_course)
      next_course = create(:course, row_position: :last)

      login(user)
      
      visit course_resource_path(resource.course, resource)
      click_link 'Completar y Continuar'
      
      expect(current_path).to eq course_path(next_course)
    end
  end

  context "when user completes last resource (and course) and there are no more courses" do
    scenario "redirects to course page", js: true do
      resource = create(:resource)
      login(user)
      
      visit course_resource_path(resource.course, resource)
      click_link 'Completar y Continuar'
      
      expect(current_path).to eq course_path(resource.course)
    end
  end

  context "when user completes a course but it's not the last resource", js: true do
    scenario "redirects to next resource" do
      resource = create(:resource, course: course)
      next_resource = create(:resource, course: course, row_position: :last)
      user.resource_completions.create(resource: next_resource) # user has already completed next resource
      
      login(user)
      
      visit course_resource_path(course, resource)
      click_link 'Completar y Continuar'
      
      expect(current_path).to eq course_resource_path(course, next_resource)
    end
  end

  scenario "marks a resource as completed", js: true do
    resource = create(:resource, course: course)
    
    login(user)
    
    visit course_path(course)
    click_link 'Recursos'
    all(:css, '.resource-additional .glyphicon-ok-circle').first.click
    
    expect(page).to have_selector '.resource-additional .completed'
    expect(current_path).to eq course_path(course)
    expect(user.resources.exists?(resource.id)).to eq true
  end
  
  scenario "unmarks a resource as completed", js: true do
    resource = create(:resource, course: course)
    create(:resource_completion, resource: resource, user: user)
    
    login(user)
    
    visit course_path(course)
    click_link 'Recursos'
    all(:css, '.resource-additional .glyphicon-ok-circle').first.click

    expect(page).not_to have_selector '.resource-additional .completed'
    expect(current_path).to eq course_path(course)
    expect(user.resources.exists?(resource.id)).to eq false
  end
end
