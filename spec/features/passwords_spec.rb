require 'rails_helper'

RSpec.feature "Password", type: :feature do

  let!(:user) { create(:user) }

  scenario 'Display form change password', js: true do
    login(user)
    find('.avatar').click
    click_link 'Cambiar Contraseña'
    wait_for_ajax
    expect(page).to have_selector '.modal-dialog'
    expect(page).to have_selector 'input#password'
    expect(page).to have_selector 'input#password_confirmation'
  end

  scenario 'Change password with valid input', js: true do
    login(user)
    find('.avatar').click
    click_link 'Cambiar Contraseña'
    wait_for_ajax
    password = Faker::Internet.password
    fill_in 'password', with: password
    fill_in 'password_confirmation', with: password
    click_button 'Cambiar Contraseña'
    expect(page).to have_selector '.alert-success'
    expect(page).to have_content 'La contraseña ha sido cambiada con éxito'
  end

  scenario 'Change password without password', js: true do
    login(user)
    find('.avatar').click
    click_link 'Cambiar Contraseña'
    wait_for_ajax
    fill_in 'password_confirmation', with: Faker::Internet.password
    click_button 'Cambiar Contraseña'
    expect(page).to have_selector '.alert-danger'
    expect(page).to have_content 'Por favor ingresa una contraseña'
  end

  scenario 'Change password without password_confirmation', js: true do
    login(user)
    find('.avatar').click
    click_link 'Cambiar Contraseña'
    wait_for_ajax
    fill_in 'password', with: Faker::Internet.password
    click_button 'Cambiar Contraseña'
    expect(page).to have_selector '.alert-danger'
  end

  scenario 'Change password when is not match', js: true do
    login(user)
    find('.avatar').click
    click_link 'Cambiar Contraseña'
    wait_for_ajax
    fill_in 'password', with: Faker::Internet.password
    fill_in 'password_confirmation', with: Faker::Internet.password
    click_button 'Cambiar Contraseña'
    expect(page).to have_selector '.alert-danger'
  end
end
