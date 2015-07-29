require 'rails_helper'

RSpec.feature "Profile", type: :feature do
  let!(:user) { create(:user) }

  let!(:user_with_private_profile) { create(:user, has_public_profile: false) }
  let!(:user_with_public_profile) { create(:user, has_public_profile: true) }
  let!(:admin) { create(:admin) }

  describe "update visibility" do
    # private access + show edition options if it's his profile
    # private access + don't show edition options if it's not his profile
    scenario "profile visibility update form", js: true do
      visit(user_profile_path(user_with_public_profile.nickname))
      expect(page).to_not have_selector(".update-profile-visibility")


      login(user_with_public_profile)
      wait_for_ajax
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

  # public access + show invitation to join MIR

end
