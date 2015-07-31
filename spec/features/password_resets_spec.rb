require 'rails_helper'

RSpec.feature "PasswordResets", type: :feature do

  let!(:original_password) { Faker::Internet.password }
  let!(:password) { Faker::Internet.password }
  let!(:other_password) { Faker::Internet.password }
  let!(:user) { create(:user,password: original_password,password_confirmation: original_password) }

  context 'a user not logged in' do
    describe "request reset password token" do

      scenario 'generate password reset token when the user exists', js: true do
        request_password_reset_token(email: user.email)
        user.reload
        expect(user.password_reset_token).not_to be_nil
        expect(user.password_reset_sent_at).not_to be_nil
        expect(page).to have_selector '.alert-notice'
      end

      scenario "don't generate password reset token when the user doesn't exist", js: true do
        request_password_reset_token(email: Faker::Internet.email)
        user.reload
        expect(user.password_reset_token).to be_nil
        expect(user.password_reset_sent_at).to be_nil
        expect(page).to have_selector '.alert-error'
      end

      scenario 'when email is empty', js: true do
        request_password_reset_token(email: '')
        user.reload
        expect(user.password_reset_token).to be_nil
        expect(user.password_reset_sent_at).to be_nil
        expect(page).to have_selector '.alert-error'
      end
    end

    context "When a user has requested a password reset token" do
      before do
        user.send_password_reset
        user.reload
      end

      scenario 'change password with valid input', js: true do
        reset_password(user: user,password: password, confirmation_password: password)

        expect(page).to have_selector '.alert-notice'
        expect(current_path).to eq login_path
        expect(user.reload.authenticate(password)).to eq user
      end

      scenario 'when password is empty', js: true do
        reset_password(user: user,password: '', confirmation_password: password)

        expect(page).to have_selector '.alert-error'
        expect(current_path).to eq password_reset_path
        expect(user.reload.authenticate(original_password)).to eq user
      end

      scenario 'when password_cofirmation is empty', js: true do
        reset_password(user: user,password: password, confirmation_password: '')
        expect(page).to have_selector '.alert-error'
        expect(current_path).to eq password_reset_path
        expect(user.reload.authenticate(original_password)).to eq user
      end

      scenario 'when not match password', js: true do
        reset_password(user: user,password: password, confirmation_password: other_password)
        expect(page).to have_selector '.alert-error'
        expect(current_path).to eq password_reset_path
        expect(user.reload.authenticate(original_password)).to eq user
      end

      scenario "and the token has expired" do
        user.update(password_reset_sent_at: Time.current - 1.year)
        visit edit_password_reset_path(token: user.password_reset_token)
        expect(current_path).to eq(login_path)
        expect(page).to have_selector '.alert-error'
      end
    end
  end
end

def request_password_reset_token(opts={})
  visit login_path
  click_link 'Ingresar'
  click_link 'He olvidado mi contraseña'
  wait_for_ajax
  find(:css, '.modal-dialog input[type="email"]').set(opts[:email])
  click_button 'Restablecer Contraseña'
  wait_for_ajax
end

def reset_password(opts={})
  visit edit_password_reset_path(token: opts[:user].password_reset_token)
  fill_in 'password_reset_password', with: opts[:password]
  fill_in  'password_reset_password_confirmation', with: opts[:confirmation_password]
  click_button 'Cambiar Contraseña'
  wait_for_ajax
end
