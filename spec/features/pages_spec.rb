require 'rails_helper'

RSpec.feature "Pages", type: :feature do
  scenario "shows handbook" do
    fake_content = "fake content"
    expect_any_instance_of(Octokit::Client).to receive(:contents).and_return(fake_content)
    visit handbook_path
    expect(page).to have_content fake_content
  end

  scenario "shows thanks page" do
    visit thanks_path
    expect(page).to have_http_status(200)
  end
end
