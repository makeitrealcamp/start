require 'rails_helper'

RSpec.feature "Resource management", type: :feature do
  let(:admin) { create(:admin) }
  let(:course) { create(:course) }

  scenario "creates an external resource" do
    login(admin)
    
    visit course_path(course)
    click_link "Nuevo Recurso"

    expect{
      fill_in 'resource_title', with: Faker::Name.title
      fill_in 'resource_description', with: Faker::Lorem.paragraph
      select "External URL", from: 'resource_type'
      fill_in 'resource_url', with: Faker::Internet.url
      fill_in 'resource_time_estimate', with: "#{Faker::Number.digit} days"
      click_button  'Crear Resource'
    }.to change(Resource, :count).by 1

    resource = Resource.last
    expect(resource).not_to be_nil
    expect(current_path).to eq course_resource_path(course, resource)
  end

  scenario "creates a Markdown resource" do
    login(admin)
    
    visit course_path(course)
    click_link "Nuevo Recurso"

    expect{
      fill_in 'resource_title', with: Faker::Name.title
      fill_in 'resource_description', with: Faker::Lorem.paragraph
      select "Markdown Document", from: 'resource_type'
      fill_in 'resource_content', with: Faker::Lorem.paragraph
      fill_in 'resource_time_estimate', with: "#{Faker::Number.digit} days"
      click_button  'Crear Resource'
    }.to change(Resource, :count).by 1

    resource = Resource.last
    expect(resource).not_to be_nil
    expect(current_path).to eq course_resource_path(course, resource)
  end

  scenario "edit resource with valid input" do
    resource = create(:resource, course: course)
    create(:resource, course: course)

    login(admin)
    visit edit_course_resource_path(course, resource)

    title = Faker::Name.title
    description =  Faker::Lorem.paragraph
    url = Faker::Internet.url
    fill_in 'resource_title', with: title
    fill_in 'resource_description', with: description
    select "External URL", from: 'resource_type'
    fill_in 'resource_url', with: url
    fill_in 'resource_time_estimate', with: "#{Faker::Number.digit} days"
    click_button  'Actualizar Resource'

    resource.reload
    expect(current_path).to eq course_resource_path(course, resource)
    
    expect(resource.title).to eq title
    expect(resource.description).to eq description
    expect(resource.url).to eq url
    expect(resource.type).to eq Resource.types.keys.first
  end

  scenario "deletes a resource", js: true do
    resource = create(:resource, course: course)
    create(:resource, course: course)

    login(admin)
    visit course_path(course, tab: 'resources')
    all('.resources span.action-remove', count: 2).first.click
    page.driver.browser.switch_to.alert.accept
    wait_for_ajax

    expect(course.resources.count).to eq 1
    expect(page).to have_selector('.resources tr', count: 1)
  end
end