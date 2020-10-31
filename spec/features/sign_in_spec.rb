require 'rails_helper'

RSpec.feature "Sign In", type: :feature do
  context "with Slack access" do
    scenario "redirects to activation form" do
      user = create(:user, status: User.statuses[:created])

      login(user)
      expect(current_path).to eq activate_users_path
    end

    scenario "handles authentication error" do
      OmniAuth.config.mock_auth[:slack] = :invalid_credentials

      visit login_slack_path
      find('#sign-in-slack').click

      expect(current_path).to eq login_slack_path
      expect(page).to have_selector '.alert-error'
    end

    scenario "redirects suspended user to login path" do
      user = create(:user, password: "test12345", status: User.statuses[:suspended])

      login(user)
      expect(current_path).to eq login_path
    end
  end

  context "with email/password access" do
    scenario "redirects to activation form" do
      user = create(:user_password, password: "test12345", status: User.statuses[:created])

      login_credentials(user)
      expect(current_path).to eq activate_users_path
    end

    scenario "handles authentication error" do
      user = create(:user_password)

      visit login_path
      fill_in "email", with: user.email
      fill_in "password", with: "wrong"

      click_on "Ingresar"

      expect(current_path).to eq login_path
      expect(page).to have_selector '.alert-error'
    end

    scenario "login is successful" do
      user = create(:user_password, password: "test12345", email: "PepePerez@example.com")
      login_credentials(user)
      expect(current_path).to eq signed_in_root_path
    end
  end
end
