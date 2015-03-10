require 'rails_helper'

RSpec.feature "Resources", type: :feature do

  let(:user){create(:user)}
  let(:admin){create(:admin)}
  let(:course){create(:course)}
  let(:resource){create(:resource, course: course)}

  scenario "show form new resource when admin is logged in", js: true do
    course = create(:course)
    create(:course)

    login(admin)
    all('a', text: 'Entrar').first.click
    find('.resources span.action-add').click
    sleep(0.1)
    expect(page.current_path).to eq new_course_resource_path(course)
  end

  scenario "show form new resource when admin is not logged in" do
    course = create(:course)

    login(user)
    visit new_course_resource_path(course)
    expect(current_path).to eq dashboard_path
  end

  scenario "create resource when admin is logged in", js: true do
    course = create(:course)
    login(admin)
    all('a', text: 'Entrar').first.click
    find('.resources span.action-add').click
    expect{
      fill_in 'resource_title', with: Faker::Name.title
      fill_in 'resource_description', with: Faker::Lorem.paragraph
      select "post", from: 'resource_type'
      fill_in 'resource_url', with: Faker::Internet.url
      click_button  'Create Resource'
    }.to change(Resource, :count).by 1

    expect(Resource.last).not_to be_nil
    expect(page.current_path).to eq course_path(course)
  end
end
