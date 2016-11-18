require 'rails_helper'

RSpec.feature "PasswordResets", type: :feature do
  context 'sends password reset' do
    scenario "without letter capital", js: true do
      user = create(:user_password)
      visit login_onsite_path

      click_link 'Olvidé mi contraseña'
      wait_for { page }.to have_css '.modal-dialog'

      find(:css, '.modal-dialog input[type="email"]').set(user.email)
      click_button 'Restablecer Contraseña'

      expect(page).to have_css '.alert-notice'

      user.reload
      expect(user.password_reset_token).not_to be_nil
      expect(user.password_reset_sent_at).not_to be_nil
    end

    scenario "with capital letter", js: true do
      user = create(:user_password, email: 'PepePerez@example.com')
      visit login_onsite_path

      click_link 'Olvidé mi contraseña'
      expect(page).to have_css '.modal-dialog'

      find(:css, '.modal-dialog input[type="email"]').set(user.email)
      click_button 'Restablecer Contraseña'

      expect(page).to have_css '.alert-notice'

      user.reload
      expect(user.password_reset_token).not_to be_nil
      expect(user.password_reset_sent_at).not_to be_nil
    end
  end

  scenario "updates password" do
    user = create(:user_password)
    user.send_password_reset

    visit edit_password_reset_path(token: user.password_reset_token)

    fill_in "Contraseña", with: "test12345"
    fill_in "Confirmar contraseña", with: "test12345"
    click_on "Cambiar Contraseña"

    expect(current_path).to eq(login_onsite_path)

  end
end
