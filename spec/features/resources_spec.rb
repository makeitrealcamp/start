require 'rails_helper'

RSpec.feature "Resources", type: :feature do
  let(:user) { create(:user_with_path) }
  let(:subject) { create(:subject) }

  scenario "shows a resource with Markdown content" do
    resource = create(:markdown, :published, subject: subject, content: "Hello World")

    login(user)
    visit subject_path(subject)
    click_link resource.title

    expect(current_path).to eq subject_resource_path(subject, resource)
    expect(page).to have_content("Hello World")
  end

  scenario "displays Make it Real's icon when resource is own" do
    resource = create(:resource, own: true, category: Resource.categories[:video_tutorial])

    login(user)
    visit subject_path(resource.subject)

    within("tr#resource_#{resource.id}") do
      expect(page).to have_selector(".label-mir")
      expect(page).to have_selector(".resource-tag.#{resource.category}")
    end
  end
end
