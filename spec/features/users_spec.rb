require 'rails_helper'

RSpec.feature "Users", type: :feature do
  scenario "activates account", js: true do
    user = create(:user, status: User.statuses[:created])

    login(user)

    original_first_name = user.first_name
    nickname = Faker::Internet.user_name(nil, %w(- _))
    number = Faker::Number.number(10)

    fill_in "activate_user_mobile_number", with: number
    fill_in "activate_user_nickname", with: nickname
    click_button 'Activar Cuenta'

    expect(current_path).to eq signed_in_root_path
    expect(page).to have_selector '.alert-notice'

    user.reload
    expect(user.status).to eq "active"
    expect(user.nickname).to eq nickname
    expect(user.mobile_number).to eq number
    expect(user.first_name).to eq original_first_name
  end

  scenario "shows profile" do
    user = create(:user_with_path)
    create(:level, required_points: 0)
    create(:level, required_points: 100)
    create(:level, required_points: 200)

    login(user)

    find('.avatar').click
    click_link "Mi Perfil"

    expect(current_path).to eq user_profile_path(user.nickname)
  end

  scenario "edits profile" do
    user = create(:user)

    login(user)

    find('.avatar').click
    click_link 'Editar Perfil'

    first_name = Faker::Name.first_name
    nickname = Faker::Internet.user_name(nil, %w(- _))
    mobile_number = Faker::Number.number(10)
    birthday = "01-01-2015"

    fill_in "user_first_name", with: first_name
    fill_in "user_nickname", with: nickname
    fill_in "user_mobile_number", with: mobile_number
    fill_in "user_birthday", with: birthday

    click_button 'Actualizar Perfil'

    expect(current_path).to eq signed_in_root_path

    user.reload
    expect(user.first_name).to eq first_name
    expect(user.mobile_number).to eq mobile_number
    expect(user.nickname).to eq nickname
    expect(user.birthday.strftime('%F')).to eq '2015-01-01'
  end

  scenario "changes visibility of profile", js: true do
    user = create(:user_with_path, has_public_profile: true)

    # check that the profile is public
    visit(user_profile_path(user.nickname))
    expect(page).to have_no_selector(".update-profile-visibility")

    login(user)
    visit(user_profile_path(user.nickname))

    # change to private
    find('#user_has_public_profile_false').click

    expect(page).to have_no_selector(".share-url")

    user.reload
    expect(user.has_public_profile).to eq false

    # change to public
    find('#user_has_public_profile_true').click

    expect(page).to have_selector(".share-url")

    user.reload
    expect(user.has_public_profile).to eq true
  end
end
