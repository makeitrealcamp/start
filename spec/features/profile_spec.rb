require 'rails_helper'

RSpec.feature "Profile", type: :feature do
  let!(:user) { create(:user) }

  let!(:user_with_private_profile) { create(:user, has_public_profile: false) }
  let!(:user_with_public_profile) { create(:user, has_public_profile: true) }
  let!(:admin) { create(:admin) }
  let!(:level)   { create(:level) }
  let!(:level_1) { create(:level_1) }
  let!(:level_2) { create(:level_2) }

  describe "update visibility" do
    scenario "profile visibility update form", js: true do
      visit(user_profile_path(user_with_public_profile.nickname))
      expect(page).to_not have_selector(".update-profile-visibility")

      login(user_with_public_profile)
      visit(user_profile_path(user_with_public_profile.nickname))

      find('#user_has_public_profile_false').click
      wait_for_ajax
      expect(user_with_public_profile.reload.has_public_profile).to eq false
      expect(page).to_not have_selector(".share-url")

      find('#user_has_public_profile_true').click
      wait_for_ajax
      expect(user_with_public_profile.reload.has_public_profile).to eq true
      expect(page).to have_selector(".share-url")
    end
  end

  describe 'when has not  completed all levels', js: true do
    scenario 'display the next level' do
      visit(user_profile_path(user_with_public_profile.nickname))
      expect(page).to have_selector('.level .row img', count: 2)
    end
  end

  describe 'when has completed all levels', js: true do
    scenario 'should not display the next level' do
      create(:point, points: 300, user: user_with_public_profile)
      visit(user_profile_path(user_with_public_profile.nickname))
      expect(page).to have_selector('.level .row img', count: 1)
    end
  end
end
  # public access + show invitation to join MIR
