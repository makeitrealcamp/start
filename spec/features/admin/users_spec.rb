require 'rails_helper'

RSpec.feature "Users management", type: :feature do
  let(:admin) { create(:admin) }

  scenario "creates a user", js: true do
    login(admin)

    visit admin_users_path
    click_link 'Nuevo alumno'

    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    email = Faker::Internet.email

    find(:css, '.modal-dialog input#user_first_name').set(first_name)
    find(:css, '.modal-dialog input#user_last_name').set(last_name)
    find(:css, '.modal-dialog input#user_email').set(email)
    find(:css, '.modal-dialog #user_gender_male').set(true)
    click_button "Crear Usuario"

    expect(page).to have_selector '.alert-success'

    user = User.find_by_email(email)
    expect(user).not_to be_nil
    expect(user.first_name).to eq first_name
    expect(user.last_name).to eq last_name
    expect(user.gender).to eq "male"
  end

  scenario "edits a user", js: true do
    user = create(:user)

    login(admin)

    visit admin_users_path
    find(:css, "#user-#{user.id} .glyphicon-edit").click

    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    email = Faker::Internet.email

    find(:css, '.modal-dialog input#user_first_name').set(first_name)
    find(:css, '.modal-dialog input#user_last_name').set(last_name)
    find(:css, '.modal-dialog input#user_email').set(email)
    find(:css, '.modal-dialog #user_gender_male').set(true)
    click_button "Actualizar Usuario"

    expect(page).to_not have_selector '.modal-dialog'
    expect(page).to have_selector '.alert-success'

    user = User.find_by_email(email)
    expect(user).not_to be_nil
    expect(user.first_name).to eq first_name
    expect(user.last_name).to eq last_name
    expect(user.gender).to eq "male"
  end
end
