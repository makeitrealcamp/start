require 'rails_helper'

RSpec.feature "Badges management", type: :feature do
  let!(:admin )    { create(:admin) }
  let!(:subject)    { create(:subject) }
  let!(:badge)     { create(:points_badge) }

  scenario "creates a badge" do
    login(admin)

    visit admin_badges_path
    click_link  'Nueva insignia'

    name = Faker::Name::name
    description = Faker::Lorem.paragraph
    image_url = "/test.png"
    required_points = 100
    expect {
      fill_in 'badge_name', with: name
      fill_in 'badge_description', with: description
      fill_in 'badge_image_url', with: image_url
      select 'Points', from: "badge_giving_method"
      fill_in 'badge_required_points', with: required_points
      select subject.name, from: "badge_subject_id"
      click_button 'Crear insignia'
    }.to change(Badge, :count).by 1

    expect(current_path).to eq admin_badges_path

    badge  = Badge.last
    expect(badge).not_to be nil
    expect(badge.name).to eq name
    expect(badge.description).to eq description
    expect(badge.image_url).to eq image_url
    expect(badge.giving_method).to eq "points"
    expect(badge.required_points).to eq required_points
    expect(Badge.count).to eq 2
    expect(badge.subject).to eq subject
  end

  scenario "edits a badge", js: true do
    login(admin)

    badge = create(:badge, giving_method: "points", required_points: 100, subject: subject)
    visit admin_badges_path

    all(:css, '.badges .glyphicon.glyphicon-pencil').last.click

    name = Faker::Name::name
    description = Faker::Lorem.paragraph
    image_url = "/test.png"
    required_points = 100
    fill_in 'badge_name', with: name
    fill_in 'badge_description', with: description
    fill_in 'badge_image_url', with: image_url
    fill_in 'badge_required_points', with: required_points
    select subject.name, from: "badge_subject_id"
    click_button 'Actualizar insignia'

    expect(current_path).to eq  admin_badges_path

    badge.reload
    expect(badge.name).to eq name
    expect(badge.description).to eq description
    expect(badge.image_url).to eq image_url
  end

  scenario "deletes a badge", js: true do
    login(admin)

    create(:badge)
    visit admin_badges_path

    all(:css, '.badges .glyphicon.glyphicon-remove').last.click
    page.driver.browser.switch_to.alert.accept
    wait_for_ajax

    expect(Badge.count).to eq 1
    expect(page).to have_selector('table.badges tbody tr', count: 1)
  end

  scenario "assigns badge to user", js: true do
    user = create(:user)
    manual_badge = create(:badge)

    login(admin)
    wait_for_ajax

    visit user_profile_path(user.nickname)
    find(:css,".add-emblem").click
    expect(page).to have_css('#new_badge_ownership')

    find(:css,'#badge_ownership_badge_id')
      .find(:css, "option[value='#{manual_badge.id}']").select_option
    click_button "Asignar"
    wait_for_ajax

    expect(user.badges.exists?(manual_badge.id)).to eq(true)
    expect(page).to have_no_css('#new_badge_ownership')
    expect(page).to have_css("#badge-#{manual_badge.id}")

    find(:css,".add-emblem").click
    expect(page).to have_no_css('#new_badge_ownership')
    within(:css, "#badge-modal") do
      expect(page).to have_content "No se le puede asignar manualmente más insignias a este usuario"
    end
  end
end
