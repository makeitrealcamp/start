require 'rails_helper'

RSpec.feature "Resources", type: :feature do
  let(:user) { create(:user_with_path) }
  let(:subject) { create(:subject) }

  scenario "shows a resource with Markdown content" do
    resource = create(:resource, type: "markdown", content: "Hello World", subject: subject)

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

  scenario "opens an external resource", js: true do
    resource = create(:resource, url: "http://localhost:3000/")

    login(user)
    visit subject_resource_path(resource.subject, resource)

    new_window = window_opened_by { click_link "Haz click acá para abrirlo" }
    within_window new_window do
      expect(page.current_url).to eq("http://localhost:3000/")
    end
  end
end
