require 'rails_helper'

RSpec.feature "Users", type: :feature do

  let!(:user) { create(:user) }
  let!(:admin) { create(:admin) }

  context 'when accessed as user' do
    scenario "when is not logged in" do
      expect { visit admin_users_path }.to raise_error
    end

    scenario "when not allow access" do
      login(user)
      expect { visit admin_users_path }.to raise_error
    end

    scenario "should not show link of admin", js: true do
      login(user)
      wait_for_ajax
      expect(page).not_to have_content('Admin')
      expect(current_path).to eq phases_path
    end

    context 'edit profile' do
      scenario "should redirect to the login  when is not logged in" do
        visit edit_user_path(user)
        expect(current_path).to eq login_path
      end

      scenario "show form edit profile" do
        login(user)
        find('.avatar').click
        click_link 'Editar Perfil'
        expect(current_path).to eq edit_user_path(user)
      end

      scenario "edit profile with valid input", js: true do
        login(user)
        first_name = Faker::Name.first_name
        mobile_number = Faker::Number.number(10)
        birthday =  '01-01-2015'
        find('.avatar').click
        click_link 'Editar Perfil'

        fill_in "user_first_name", with: first_name
        fill_in "user_mobile_number", with: mobile_number
        fill_in "user_birthday", with: birthday

        click_button 'Actualizar Perfil'

        wait_for_ajax
        user.reload
        sleep(1.0)
        expect(user.first_name).to eq first_name
        expect(user.mobile_number).to eq mobile_number
        expect(user.birthday.strftime('%F')).to eq '2015-01-01'
        expect(current_path).to eq phases_path
      end
    end
  end

  context 'when accessed as admin' do
    scenario "show list users", js: true do
      login(admin)
      visit admin_users_path
      wait_for_ajax
      expect(current_path).to eq admin_users_path
    end

    scenario "show link of users", js: true do
      login(admin)
      wait_for_ajax
      expect(all('a', text: 'Admin').count).to eq 1
      expect(current_path).to eq phases_path
    end
  end

  context 'with Facebook account', js: true do
    scenario "can sign in user" do
      mock_auth_hash_facebook
      visit login_path
      find('#sign-in-facebook').click
      sleep(1.0)
      expect(current_path).to eq phases_path
    end

    scenario 'can handle authentication error ' do
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      visit login_path
      find('#sign-in-facebook').click
      wait_for_ajax
      expect(page).to have_content 'Es necesario que autorices los permisos para poder ingresar a Make it Real. También puedes regístrate con email y contraseña.'
      expect(current_path).to eq signup_path
    end
  end

  context 'with github account', js: true do
    scenario "can sign in user" do
      mock_auth_hash_github
      visit login_path
      find('#sign-in-github').click
      sleep(1.0)
      expect(current_path).to eq phases_path
    end

    scenario 'can handle authentication error' do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials
      visit login_path
      find('#sign-in-github').click
      wait_for_ajax
      expect(page).to have_content 'Es necesario que autorices los permisos para poder ingresar a Make it Real. También puedes regístrate con email y contraseña.'
      expect(current_path).to eq signup_path
    end
  end
end
