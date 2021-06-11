require 'rails_helper'

RSpec.feature "Resource management", type: :feature do
  let(:admin) { create(:admin_user) }
  let(:subject) { create(:subject) }

  scenario "creates an external resource" do
    login(admin)

    visit subject_path(subject)
    click_link "Nuevo Recurso"

    expect{
      fill_in 'resource_title', with: Faker::Commerce.product_name
      fill_in 'resource_description', with: Faker::Lorem.paragraph
      select "External URL", from: 'resource_type'
      fill_in 'resource_url', with: Faker::Internet.url
      fill_in 'resource_time_estimate', with: "#{Faker::Number.digit} days"
      click_button  'Crear Resource'
    }.to change(Resource, :count).by 1

    resource = Resource.last
    expect(resource).not_to be_nil
    expect(current_path).to eq subject_resource_path(subject, resource)
  end

  scenario "creates a Markdown resource" do
    login(admin)

    visit subject_path(subject)
    click_link "Nuevo Recurso"

    expect{
      fill_in 'resource_title', with: Faker::Commerce.product_name
      fill_in 'resource_description', with: Faker::Lorem.paragraph
      select "Markdown Document", from: 'resource_type'
      fill_in 'resource_content', with: Faker::Lorem.paragraph
      fill_in 'resource_time_estimate', with: "#{Faker::Number.digit} days"
      click_button  'Crear Resource'
    }.to change(Resource, :count).by 1

    resource = Resource.last
    expect(resource).not_to be_nil
    expect(current_path).to eq subject_resource_path(subject, resource)
  end

  scenario "edit resource with valid input" do
    resource = create(:external_url, subject: subject)
    create(:resource, subject: subject)

    login(admin)
    visit edit_subject_resource_path(subject, resource)

    title = Faker::Commerce.product_name
    description =  Faker::Lorem.paragraph
    url = Faker::Internet.url
    fill_in 'resource_title', with: title
    fill_in 'resource_description', with: description
    fill_in 'resource_url', with: url
    fill_in 'resource_time_estimate', with: "#{Faker::Number.digit} days"
    click_button  'Actualizar Resource'

    resource.reload
    expect(current_path).to eq subject_resource_path(subject, resource)

    expect(resource.title).to eq title
    expect(resource.description).to eq description
    expect(resource.url).to eq url
  end

  scenario "deletes a resource", js: true do
    resource = create(:resource, subject: subject)
    create(:resource, subject: subject)

    login(admin)
    visit subject_path(subject, tab: 'resources')
    all('.resources span.action-remove', count: 2).first.click
    page.driver.browser.switch_to.alert.accept
    wait_for_ajax

    expect(subject.resources.count).to eq 1
    expect(page).to have_selector('.resources tr', count: 1)
  end
end
