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
      expect(current_path).to eq signed_in_root_path
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
        expect(current_path).to eq signed_in_root_path
      end
    end
  end

  context 'when accessed as admin' do
    context 'create user', js: true do
      scenario 'display form' do
        login(admin)
        wait_for_ajax
        visit admin_users_path
        click_link 'Nuevo usuario'
        expect(page).to have_selector "#create-user-modal"
      end

      scenario 'with valid input ' do
        login(admin)
        wait_for_ajax
        visit admin_users_path
        click_link 'Nuevo usuario'
        wait_for_ajax

        first_name = Faker::Name.first_name
        last_name = Faker::Name.last_name
        email = Faker::Internet.email

        find(:css, '.modal-dialog input#user_first_name').set(first_name)
        find(:css, '.modal-dialog input#user_last_name').set(last_name)
        find(:css, '.modal-dialog input#user_email').set(email)
        find(:css, '.modal-dialog #user_gender_male').set(true)
        click_button "Crear Usuario"
        wait_for_ajax
        user = User.last
        expect(user).not_to be_nil
        expect(user.first_name).to eq first_name
        expect(user.last_name).to eq last_name
        expect(user.email).to eq  email
        expect(user.gender).to eq "male"
        expect(page).to have_selector '.alert-success'
      end

      scenario 'without valid input' do
        login(admin)
        wait_for_ajax
        visit admin_users_path
        click_link 'Nuevo usuario'
        wait_for_ajax
        click_button "Crear Usuario"
        expect(page).to have_selector '.alert-danger'
      end
    end

    scenario "show list users" do
      login(admin)
      visit admin_users_path
      expect(current_path).to eq admin_users_path
    end

    scenario "show link of users", js: true do
      login(admin)
      wait_for_ajax
      expect(all('a', text: 'Admin').count).to eq 1
      expect(current_path).to eq signed_in_root_path
    end
  end

  context 'when activate the account' do
    scenario 'display form' do
      user = create(:user, status: "created")
      user.send_activate_mail
      visit url_for(only_path: false, controller: 'users', action: 'activate_form', id: user.id, v: user.password_reset_token)
      expect(page).to have_selector ".edit_user"
    end

    scenario 'with valid input' do
      user = create(:user, status: "created")
      user.send_activate_mail
      visit url_for(only_path: false, controller: 'users', action: 'activate_form', id: user.id, v: user.password_reset_token)

      mobile_number = Faker::Number.number(10)
      birthday =  '01-01-2015'
      nickname = Faker::Internet.user_name
      password = Faker::Internet.password(8)
      password_confirmation = password

      fill_in "user_mobile_number", with: mobile_number
      fill_in "user_birthday", with: birthday
      fill_in "user_nickname", with: nickname
      find(:css, '.edit_user #user_has_public_profile_true').set(true)
      find(:css, '.edit_user #user_gender_male').set(true)
      fill_in "user_password", with: password
      fill_in "user_password_confirmation", with: password_confirmation
      click_button 'Activar Cuenta'
      user.reload
      expect(user.mobile_number).to eq mobile_number
      expect(user.birthday.strftime('%F')).to eq '2015-01-01'
      expect(user.nickname).to eq nickname
      expect(user.gender).to eq "male"
      expect(user.has_public_profile).to eq true
      expect(user.status).to eq "active"
      expect(page).to have_selector '.alert-top-notice'
      expect(current_path).to eq login_path
    end


    scenario 'without valid input' do
      user = create(:user, status: "created")
      user.send_activate_mail
      visit url_for(only_path: false, controller: 'users', action: 'activate_form', id: user.id, v: user.password_reset_token)
      mobile_number = Faker::Number.number(10)
      birthday =  '01-01-2015'
      nickname = Faker::Internet.user_name
      password = Faker::Internet.password(8)
      password_confirmation = password

      fill_in "user_mobile_number", with: mobile_number
      fill_in "user_birthday", with: birthday
      find(:css, '.edit_user #user_has_public_profile_true').set(true)
      find(:css, '.edit_user #user_gender_male').set(true)
      click_button 'Activar Cuenta'
      expect(page).to have_selector ".panel-danger"
      expect(current_path).to eq activate_user_path(user)
    end
  end
end
