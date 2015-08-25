require 'rails_helper'


RSpec.feature "Sign In", type: :feature do
  let!(:user) { create(:paid_user) }

  context 'when user is free'  do
    scenario 'should redirect to root path' do
      user = create(:user)
      visit login_path
      login(user)
      expect(current_path).to eq root_path
      expect(page).to have_selector '.alert-notice'
    end

    context 'with Facebook account' do
      scenario 'should redirect to root path' do
        user = create(:user)
        mock_auth_hash_facebook(user)
        visit login_path
        find('#sign-in-facebook').click
        expect(current_path).to eq root_path
        expect(page).to have_selector '.alert-notice'
      end
    end

    context 'with github account' do
      scenario 'should redirect to root path' do
        user = create(:user)
        mock_auth_hash_github(user)
        visit login_path
        find('#sign-in-github').click
        expect(current_path).to eq root_path
        expect(page).to have_selector '.alert-notice'
      end
    end
  end

  context 'with Facebook account' do
    scenario "can sign in user" do
      mock_auth_hash_facebook(user)
      visit login_path
      find('#sign-in-facebook').click
      expect(current_path).to eq signed_in_root_path
    end

    scenario 'can handle authentication error', js: true do
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      visit login_path
      find('#sign-in-facebook').click
      expect(current_path).to eq login_path
      expect(page).to have_selector '.alert-error'
    end
  end

  context 'with github account' do
    scenario "can sign in user" do
      mock_auth_hash_github(user)
      visit login_path
      find('#sign-in-github').click
      expect(current_path).to eq signed_in_root_path
    end

    scenario 'can handle authentication error', js: true do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials
      visit login_path
      find('#sign-in-github').click
      expect(current_path).to eq login_path
      expect(page).to have_selector ".alert-error"
    end
  end
end
