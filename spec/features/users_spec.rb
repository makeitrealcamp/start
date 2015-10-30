require 'rails_helper'

RSpec.feature "Users", type: :feature do

  let!(:user) { create(:paid_user) }
  let!(:admin) { create(:admin) }

  scenario "when is not logged in" do
    expect { visit admin_users_path }.to raise_error
  end

  context 'when accessed as user' do
    scenario "not allow access" do
      login(user)
      expect { visit admin_users_path }.to raise_error ActionController::RoutingError
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

      scenario "show form edit profile", js: true do
        login(user)
        wait_for_ajax
        find('.avatar').click
        click_link 'Editar Perfil'
        expect(current_path).to eq edit_user_path(user)
      end

      scenario "edit profile with valid input", js: true do
        login(user)
        wait_for_ajax
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
    let!(:user) {create(:user, status: "created")}

    before do
      user.send_activate_mail
    end

    scenario 'with valid input' do
      original_first_name = user.first_name
      nickname = Faker::Internet.user_name('Nancy')
      number = Faker::Number.number(10)
      activate_account(
        token: user.password_reset_token,
        nickname: nickname,
        mobile_number: number
      )
      user.reload
      expect(user.status).to eq "active"
      expect(user.nickname).to eq nickname
      expect(user.mobile_number).to eq number
      expect(user.first_name).to eq original_first_name
      expect(current_path).to eq login_path
      expect(page).to have_selector '.alert-notice'
    end

    context 'when without valid input' do
      scenario 'with existing nickname' do
        nickname = Faker::Internet.user_name('Nancy')
        number = Faker::Number.number(10)
        create(:user,nickname: nickname)

        activate_account(
          token: user.password_reset_token,
          nickname: nickname,
          gender: 'male',
          has_public_profile: true,
          mobile_number: number
        )

        user.reload
        expect(user.status).to eq "created"
        expect(user.nickname).to_not eq 'simon0191'
        expect(page).to have_selector ".alert-error"
        expect(current_path).to eq activate_users_path
      end

      scenario 'with nickname format is not valid' do
        nickname = Faker::Internet.user_name('Nancy Johnson', %w(. _ -))
        activate_account(
          token: user.password_reset_token,
          nickname: nickname
        )
        expect(user.status).to eq "created"
        expect(page).to have_selector ".alert-error"
        expect(current_path).to eq activate_users_path
      end
    end
  end
end


def activate_account(opts={})
  visit activate_users_path(token: opts[:token])
  fill_in "activate_user_mobile_number", with: opts[:mobile_number]
  fill_in "activate_user_birthday", with: opts[:birthday]
  fill_in "activate_user_nickname", with: opts[:nickname]
  click_button 'Activar Cuenta'
end
