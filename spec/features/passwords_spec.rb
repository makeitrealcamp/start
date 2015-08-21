require 'rails_helper'

RSpec.feature "Password", type: :feature do
  let!(:original_password) { Faker::Internet.password }
  let!(:password) { Faker::Internet.password }
  let!(:other_password) { Faker::Internet.password }
  let!(:user) { create(:paid_user, password: original_password, password_confirmation: original_password) }

  context "Change password" do
    scenario 'with valid input', js: true do
      change_password(user: user, new_password: password, new_password_confirmation: password)
      expect(page).to have_selector '.alert-success'
      expect(user.reload.authenticate(password)).to eq(user)
    end

    scenario 'without password', js: true do
      change_password(user: user, new_password: '', new_password_confirmation: '')
      expect(page).to have_selector '.alert-danger'
      expect(user.reload.authenticate(original_password)).to eq(user)
    end

    scenario 'without password_confirmation', js: true do
      change_password(user: user, new_password: password, new_password_confirmation: '')
      expect(page).to have_selector '.alert-danger'
      expect(user.reload.authenticate(original_password)).to eq(user)
    end

    scenario 'with password different from password confirmation', js: true do
      change_password(user: user, new_password: password, new_password_confirmation: other_password)
      expect(page).to have_selector '.alert-danger'
      expect(user.reload.authenticate(original_password)).to eq(user)
    end
  end
end


def change_password(opts = {})
  login(opts[:user])
  find('.avatar').click
  click_link 'Cambiar Contraseña'
  wait_for_ajax
  fill_in 'password_change_password', with: opts[:new_password]
  fill_in 'password_change_password_confirmation', with: opts[:new_password_confirmation]
  click_button 'Cambiar Contraseña'
end
