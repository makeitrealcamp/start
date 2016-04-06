require 'rails_helper'

RSpec.feature "Sign In", type: :feature do
  let!(:user) { create(:user) }

  scenario "redirects user to activation form" do
    user.created!

    login(user)
    expect(current_path).to eq activate_users_path
  end

  scenario "handles authentication error", js: true do
    OmniAuth.config.mock_auth[:slack] = :invalid_credentials

    visit login_path
    find('#sign-in-slack').click

    expect(current_path).to eq login_path
    expect(page).to have_selector '.alert-error'
  end

  scenario "redirects suspended user to root path" do
    user.suspended!

    login(user)
    expect(current_path).to eq root_path
  end
end
