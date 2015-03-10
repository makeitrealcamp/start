require 'rails_helper'

RSpec.feature "Resources", type: :feature do

  let(:user){create(:user)}
  let(:admin){create(:admin)}
  let(:course){create(:course)}
  let(:resource){create(:resource, course: course)}

  context 'as user' do

    scenario "should redirect to the login  when is not logged in" do
      course = create(:course)
      visit new_course_resource_path(course)
      expect(current_path).to eq login_path
    end

    scenario "should redirect to the dashboard when not is admin", js: true do
      course = create(:course)
      login(user)
      visit new_course_resource_path(course)
      expect(current_path).to eq dashboard_path
      expect(page).to have_content
    end
  end

  context 'as admin' do
    scenario "show form new resource", js: true do
      course = create(:course)
      create(:course)

      login(admin)
      all('a', text: 'Entrar').first.click
      find('.resources span.action-add').click
      sleep(0.1)
      expect(page.current_path).to eq new_course_resource_path(course)
    end

    scenario "create resource with valid input", js: true do
      course = create(:course)
      login(admin)
      all('a', text: 'Entrar').first.click
      find('.resources span.action-add').click
      expect{
        fill_in 'resource_title', with: Faker::Name.title
        fill_in 'resource_description', with: Faker::Lorem.paragraph
        select Resource.types.keys.last, from: 'resource_type'
        fill_in 'resource_url', with: Faker::Internet.url
        fill_in 'resource_time_estimate', with: "#{Faker::Number.digit} days"
        click_button  'Create Resource'
      }.to change(Resource, :count).by 1

      expect(Resource.last).not_to be_nil
      expect(current_path).to eq course_path(course)
    end


    scenario "show form edit resource", js: true do
      resource = create(:resource, course: course)
      create(:resource, course: course)
      login(admin)
      all('a', text: 'Entrar').first.click
      all('.resources span.action-edit', count: 2).first.click
      sleep(0.1)
      expect(current_path).to eq edit_resource_path(resource)
    end

    scenario "edit resource with valid input", js: true do
      resource = create(:resource, course: course)
      create(:resource, course: course)

      login(admin)

      all('a', text: 'Entrar').first.click
      all('.resources span.action-edit', count: 2).first.click
      title = Faker::Name.title
      description =  Faker::Lorem.paragraph
      url = Faker::Internet.url

      fill_in 'resource_title', with: title
      fill_in 'resource_description', with: description
      select Resource.types.keys.first, from: 'resource_type'
      fill_in 'resource_url', with: url
      fill_in 'resource_time_estimate', with: "#{Faker::Number.digit} days"
      click_button  'Update Resource'

      resource = Resource.find(resource.id)
      expect(resource.title).to eq title
      expect(resource.description).to eq description
      expect(resource.url).to eq url
      expect(resource.type).to eq Resource.types.keys.first
      sleep(0.1)
      expect(current_path).to eq course_path(course)
    end

    scenario "edit resource without valid input", js: true do
      resource = create(:resource, course: course)
      create(:resource, course: course)

      login(admin)

      all('a', text: 'Entrar').first.click
      all('.resources span.action-edit', count: 2).first.click
      title = Faker::Name.title
      description =  Faker::Lorem.paragraph
      url = Faker::Internet.url

      fill_in 'resource_title', with: title
      fill_in 'resource_description', with: nil
      select Resource.types.keys.first, from: 'resource_type'
      fill_in 'resource_url', with: url
      fill_in 'resource_time_estimate', with: "#{Faker::Number.digit} days"
      click_button  'Update Resource'

      sleep(0.1)
      expect(page).to have_selector ".panel-danger"

      expect(current_path).to eq resource_path(resource)

    end
  end
end
