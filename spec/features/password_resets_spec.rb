require 'rails_helper'

RSpec.feature "PasswordResets", type: :feature do

  let!(:user) { create(:user) }

  context 'as user not logged in' do
    scenario 'display form reset password', js: true do
      visit root_path
      click_link 'Ingresar'
      click_link 'Restablecer la contraseña'
      wait_for_ajax
      expect(page).to have_selector '.modal-dialog'
      expect(page).to have_selector 'input#email'
    end

    scenario 'generate password reset token when the user exist', js: true do
      visit root_path
      click_link 'Ingresar'
      click_link 'Restablecer la contraseña'
      wait_for_ajax
      find(:css, '.modal-dialog input#email').set(user.email)
      click_button 'Restablecer Contraseña'
      wait_for_ajax
      user.reload
      expect(user.password_reset_token).not_to be_nil
      expect(user.password_reset_sent_at).not_to be_nil
      expect(page).to have_selector '.alert-success'
    end

    scenario 'not generate password reset token when the user not exist', js: true do
      visit root_path
      click_link 'Ingresar'
      click_link 'Restablecer la contraseña'
      wait_for_ajax
      find(:css, '.modal-dialog input#email').set(Faker::Internet.email)
      click_button 'Restablecer Contraseña'
      wait_for_ajax
      user.reload
      expect(page).to have_selector '.alert-danger'
      expect(page).to have_content  'El correo electrónico no existe en la base de datos'
    end

    scenario 'when email is empty', js: true do
      visit root_path
      click_link 'Ingresar'
      click_link 'Restablecer la contraseña'
      wait_for_ajax
      click_button 'Restablecer Contraseña'
      wait_for_ajax
      user.reload
      expect(page).to have_selector '.alert-danger'
      expect(page).to have_content  'Por favor digite un correo electrónico'
    end

    scenario 'Display form change password', js: true do
      visit root_path
      click_link 'Ingresar'
      click_link 'Restablecer la contraseña'
      wait_for_ajax
      find(:css, '.modal-dialog input#email').set(user.email)
      click_button 'Restablecer Contraseña'
      wait_for_ajax
      user.reload
      visit edit_password_resets_path(t: user.password_reset_token)
      expect(page).to have_content 'Restablecer Contraseña'
      expect(page).to have_selector '#user_password'
      expect(page).to have_selector '#user_password_confirmation'
    end

    scenario 'change password with valid input', js: true do
      visit root_path
      click_link 'Ingresar'
      click_link 'Restablecer la contraseña'
      wait_for_ajax
      find(:css, '.modal-dialog input#email').set(user.email)
      click_button 'Restablecer Contraseña'
      wait_for_ajax
      user.reload
      visit edit_password_resets_path(t: user.password_reset_token)
      password = Faker::Internet.password
      fill_in 'user_password', with: password
      fill_in  'user_password_confirmation', with: password
      click_button 'Cambiar Contraseña'
      wait_for_ajax
      expect(page).to have_content 'la contraseña se ha restablecido correctamente'
      expect(current_path).to eq login_path
    end

    scenario 'when password is empty', js: true do
      visit root_path
      click_link 'Ingresar'
      click_link 'Restablecer la contraseña'
      wait_for_ajax
      find(:css, '.modal-dialog input#email').set(user.email)
      click_button 'Restablecer Contraseña'
      wait_for_ajax
      user.reload
      visit edit_password_resets_path(t: user.password_reset_token)
      fill_in  'user_password_confirmation', with: Faker::Internet.password
      click_button 'Cambiar Contraseña'
      wait_for_ajax
      expect(page).to have_selector '.panel-danger'
      expect(current_path).to eq password_resets_path
    end

    scenario 'when password_cofirmation is empty', js: true do
      visit root_path
      click_link 'Ingresar'
      click_link 'Restablecer la contraseña'
      wait_for_ajax
      find(:css, '.modal-dialog input#email').set(user.email)
      click_button 'Restablecer Contraseña'
      wait_for_ajax
      user.reload
      visit edit_password_resets_path(t: user.password_reset_token)
      fill_in  'user_password', with: Faker::Internet.password
      click_button 'Cambiar Contraseña'
      wait_for_ajax
      expect(page).to have_selector '.panel-danger'
      expect(current_path).to eq password_resets_path
    end

    scenario 'when not match password', js: true do
      visit root_path
      click_link 'Ingresar'
      click_link 'Restablecer la contraseña'
      wait_for_ajax
      find(:css, '.modal-dialog input#email').set(user.email)
      click_button 'Restablecer Contraseña'
      wait_for_ajax
      user.reload
      visit edit_password_resets_path(t: user.password_reset_token)
      fill_in  'user_password', with: Faker::Internet.password
      fill_in  'user_password_confirmation', with: Faker::Internet.password
      click_button 'Cambiar Contraseña'
      wait_for_ajax
      expect(page).to have_selector '.panel-danger'
      expect(current_path).to eq password_resets_path
    end
  end
end
