require 'rails_helper'

RSpec.feature "PasswordResets", type: :feature do

  let!(:user) { create(:user) }

  context 'as user not logged in' do
    describe "request reset password token" do
      scenario 'display form reset password', js: true do
        visit login_path
        click_link 'Ingresar'
        click_link 'He olvidado mi contraseña'
        wait_for_ajax
        expect(page).to have_selector '.modal-dialog input[type="email"]'
      end

      scenario 'generate password reset token when the user exists', js: true do
        visit login_path
        click_link 'Ingresar'
        click_link 'He olvidado mi contraseña'
        wait_for_ajax
        find(:css, '.modal-dialog input[type="email"]').set(user.email)
        click_button 'Restablecer Contraseña'
        wait_for_ajax
        user.reload
        expect(user.password_reset_token).not_to be_nil
        expect(user.password_reset_sent_at).not_to be_nil
        expect(page).to have_selector '.alert-notice'
      end

      scenario "don't generate password reset token when the user doesn't exist", js: true do
        visit login_path
        click_link 'Ingresar'
        click_link 'He olvidado mi contraseña'
        wait_for_ajax
        find(:css, '.modal-dialog input[type="email"]').set(Faker::Internet.email)
        click_button 'Restablecer Contraseña'
        wait_for_ajax
        user.reload
        expect(page).to have_selector '.alert-error'
      end

      scenario 'when email is empty', js: true do
        visit login_path
        click_link 'Ingresar'
        click_link 'He olvidado mi contraseña'
        wait_for_ajax
        click_button 'Restablecer Contraseña'
        wait_for_ajax
        user.reload
        expect(page).to have_selector '.alert-error'
      end
    end

    context "When a user has requested a password reset token" do
      before do
        user.send_password_reset
        user.reload
      end

      scenario 'change password with valid input', js: true do
        visit edit_password_reset_path(token: user.password_reset_token)
        password = Faker::Internet.password
        fill_in 'password_reset_password', with: password
        fill_in  'password_reset_password_confirmation', with: password
        click_button 'Cambiar Contraseña'
        wait_for_ajax
        expect(page).to have_selector '.alert-notice'
        expect(current_path).to eq login_path
        expect(user.reload.authenticate(password)).to eq user
      end

      scenario 'when password is empty', js: true do
        visit edit_password_reset_path(token: user.password_reset_token)
        fill_in  'password_reset_password_confirmation', with: Faker::Internet.password
        click_button 'Cambiar Contraseña'
        wait_for_ajax
        expect(page).to have_selector '.alert-error'
        expect(current_path).to eq password_reset_path
      end

      scenario 'when password_cofirmation is empty', js: true do
        visit edit_password_reset_path(token: user.password_reset_token)
        fill_in  'password_reset_password', with: Faker::Internet.password
        click_button 'Cambiar Contraseña'
        wait_for_ajax
        expect(page).to have_selector '.alert-error'
        expect(current_path).to eq password_reset_path
      end

      scenario 'when not match password', js: true do
        visit edit_password_reset_path(token: user.password_reset_token)
        fill_in  'password_reset_password', with: Faker::Internet.password
        fill_in  'password_reset_password_confirmation', with: Faker::Internet.password
        click_button 'Cambiar Contraseña'
        wait_for_ajax
        expect(page).to have_selector '.alert-error'
        expect(current_path).to eq password_reset_path
      end
    end
  end
end
