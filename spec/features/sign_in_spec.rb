require 'rails_helper'

RSpec.feature "Sign In", type: :feature do
  let!(:user) { create(:paid_user) }
  let!(:user_free){ create(:user) }

  context 'when user is free'  do
    scenario 'should redirect to root path', js: true do
      login(user_free)
      expect(current_path).to eq root_path
      expect(page).to have_css('.alert-notice')
    end
  end

  context 'when user is paid', js: true do
    context 'when is created' do
      scenario 'should redirect to form activate' do
        user.created!
        login(user)
        wait_for_ajax
        expect(current_path).to eq activate_users_path
      end
    end

    scenario 'can sign in' do
      login(user)
      wait_for_ajax
      expect(current_path).to eq signed_in_root_path
    end
  end

  scenario 'can handle authentication error', js: true do
    OmniAuth.config.mock_auth[:slack] = :invalid_credentials
    visit login_path
    find('#sign-in-slack').click
    expect(current_path).to eq login_path
    expect(page).to have_selector '.alert-error'
  end
end
