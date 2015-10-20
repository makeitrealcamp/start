require 'rails_helper'

RSpec.feature "Lessons", type: :feature do

  scenario "Navigate to handbook" do
    fake_content = "fake content"
    expect_any_instance_of(Octokit::Client).to receive(:contents).and_return(fake_content)
    visit handbook_path
    expect(page).to have_content fake_content
  end

end
