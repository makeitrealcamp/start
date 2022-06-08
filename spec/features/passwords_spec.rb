require 'rails_helper'

RSpec.feature "Passwords", type: :feature do
  scenario "user changes password", js: true do
    user = create(:user_password)
    user.update(password: "test1234")

    login_credentials(user)

    find('.avatar').click
    expect(page).to have_css('.dropdown.open .avatar')
    click_link 'Cambiar Contraseña'
    expect(page).to have_css('.modal-dialog')

    fill_in "Nueva Contraseña", with: "test0987"
    fill_in "Confirma Contraseña", with: "test0987"

    click_button "Cambiar Contraseña"

    expect(page).to have_selector('.alert-notice')
  end
end
