require 'rails_helper'

RSpec.feature "Users", type: :feature do

  let!(:user) { create(:paid_user) }
  let!(:admin) { create(:admin) }

  context 'when accessed as user' do
    scenario "when is not logged in" do
      expect { visit admin_users_path }.to raise_error
    end

    scenario "when not allow access" do
      login(user)
      expect { visit admin_users_path }.to raise_error
    end

    scenario "should not show link of admin" do
      login(user)
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

      scenario "edit profile with valid input" do
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
        user = User.find_by_email(email)
        expect(user).not_to be_nil
        expect(user.first_name).to eq first_name
        expect(user.last_name).to eq last_name
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
  end

  describe 'account activation' do

    let!(:password) { Faker::Internet.password(8) }
    let!(:other_password) { Faker::Internet.password(8) }
    let!(:original_password) { Faker::Internet.password(8) }
    let!(:user) {create(:user, status: "created", password: original_password, password_confirmation: original_password)}

    before do
      user.send_activate_mail
    end

    scenario 'with valid input' do
      original_first_name = user.first_name
      activate_account(
        token: user.password_reset_token,
        password: password,
        password_confirmation: password,
        nickname: 'pepito',
        gender: 'male',
        has_public_profile: true,
        mobile_number: '3001234567'
      )
      user.reload
      expect(user.authenticate(password)).to eq user
      expect(user.status).to eq "active"
      expect(user.nickname).to eq 'pepito'
      expect(user.gender).to eq 'male'
      expect(user.has_public_profile).to eq true
      expect(user.mobile_number).to eq '3001234567'
      expect(user.first_name).to eq original_first_name

      expect(current_path).to eq login_path
      expect(page).to have_selector '.alert-notice'
    end

    scenario 'with existing nickname' do
      create(:user,nickname: "simon0191")

      activate_account(
        token: user.password_reset_token,
        password: password,
        password_confirmation: password,
        nickname: 'simon0191',
        gender: 'male',
        has_public_profile: true,
        mobile_number: '3001234567'
      )
      user.reload

      expect(user.authenticate(original_password)).to eq user
      expect(user.status).to eq "created"
      expect(user.nickname).to_not eq 'simon0191'

      expect(page).to have_selector ".alert-error"
      expect(current_path).to eq activate_users_path

    end


    scenario 'with invalid input' do
      activate_account(
        token: user.password_reset_token,
        password: password,
        password_confirmation: other_password,
        nickname: 'pepito'
      )

      expect(user.authenticate(original_password)).to eq user
      expect(user.status).to eq "created"
      expect(user.nickname).to_not eq 'pepito'

      expect(page).to have_selector ".alert-error"
      expect(current_path).to eq activate_users_path
    end
  end
end


def activate_account(opts={})

  visit activate_users_path(token: opts[:token])

  fill_in "activate_user_mobile_number", with: opts[:mobile_number]
  fill_in "activate_user_birthday", with: opts[:birthday]
  fill_in "activate_user_nickname", with: opts[:nickname]

  find(:css, '#activate_user_has_public_profile_true').set(true) if opts[:has_public_profile] == true
  find(:css, '#activate_user_has_public_profile_false').set(true) if opts[:has_public_profile] == false

  find(:css, '#activate_user_gender_male').set(true) if opts[:gender] == "male"
  find(:css, '#activate_user_gender_male').set(true) if opts[:gender] == "female"

  fill_in "activate_user_password", with: opts[:password]
  fill_in "activate_user_password_confirmation", with: opts[:password_confirmation]

  click_button 'Activar Cuenta'
end
