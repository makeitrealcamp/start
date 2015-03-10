require 'rails_helper'

RSpec.feature "Resources", type: :feature do

  let(:user){create(:user)}
  let(:admin){create(:admin)}
  let(:course){create(:course)}
  let(:resource){create(:resource, course: course)}

  context 'as user' do
    scenario "should redirect to the dashboard when not is admin", js: true do
      course = create(:course)
      login(user)
      visit new_course_resource_path(course)
      expect(current_path).to eq dashboard_path
      expect(page).to have_content
    end

    scenario "should redirect to the login  when is not logged in" do
      course = create(:course)
      visit new_course_resource_path(course)
      expect(current_path).to eq login_path
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


    scenario "create resource without valid input", js: true do
      course = create(:course)
      login(admin)
      all('a', text: 'Entrar').first.click
      find('.resources span.action-add').click
      expect{
        fill_in 'resource_title', with: Faker::Name.title
        select Resource.types.keys.last, from: 'resource_type'
        fill_in 'resource_url', with: Faker::Internet.url
        click_button  'Create Resource'
      }.not_to change(Resource, :count)

      expect(Resource.last).to be_nil
      expect(current_path).to eq  course_resources_path(course)
    end
  end

end
