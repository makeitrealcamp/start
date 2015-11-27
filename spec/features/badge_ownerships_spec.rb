require 'rails_helper'

RSpec.feature "Manually assign Badges", type: :feature do
  let!(:user)      { create(:user) }
  let!(:admin )    { create(:admin) }
  let!(:course)    { create(:course) }
  let!(:badge)     { create(:manually_assigned_badge) }


  scenario "Manually assign badges to user", js: true do
    login(admin)
    wait_for_ajax
    visit user_profile_path(user.nickname)
    find(:css,".add-emblem").click
    expect(page).to have_css('#new_badge_ownership')

    find(:css,'#badge_ownership_badge_id')
      .find(:css, "option[value='#{badge.id}']").select_option

    click_button "Asignar"
    wait_for_ajax
    expect(user.badges.exists?(badge.id)).to eq(true)
    expect(page).to have_no_css('#new_badge_ownership')
    expect(page).to have_css("#badge-#{badge.id}")
    find(:css,".add-emblem").click
    expect(page).to have_no_css('#new_badge_ownership')
    within(:css,"#badge-modal") do
      expect(page).to have_content "No se le puede asignar manualmente más insignias a este usuario"
    end
  end

end
