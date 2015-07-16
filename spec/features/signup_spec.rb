# encoding: UTF-8
require "rails_helper"

RSpec.feature "Sign Up", type: :feature do
  xscenario "when user is logged in" do
    login(create(:user))
    visit signup_path
    expect(current_path).to eq signed_in_root_path
  end

  xscenario "with valid attributes" do
    visit signup_path
    fill_in 'user_email', with: Faker::Internet.email
    password  = Faker::Internet.password
    fill_in 'user_password', with: password
    fill_in 'user_password_confirmation', with: password
    click_button 'Crear cuenta'
    expect(current_path).to eq signed_in_root_path
  end

  xscenario "with invalid email" do
    visit signup_path
    fill_in 'user_email', with: 'invalid'
    fill_in 'user_password', with: Faker::Internet.password
    click_button 'Crear cuenta'

    expect(current_path).to eq signup_path
    expect(page).to have_content "Email no es válido"
  end

  xscenario "with existing email" do
    user = create(:user)

    visit signup_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: Faker::Internet.password
    click_button 'Crear cuenta'

    expect(current_path).to eq signup_path
    expect(page).to have_content "Email ya está en uso"
  end

  xscenario "with no password" do
    visit signup_path
    fill_in 'user_email', with: Faker::Internet.email
    click_button 'Crear cuenta'

    expect(current_path).to eq signup_path
    expect(page).to have_content "Password no puede estar en blanco"
  end

  xscenario "with no password confirmation" do
    visit signup_path
    fill_in 'user_email', with: Faker::Internet.email
    fill_in 'user_password', with: Faker::Internet.password
    click_button 'Crear cuenta'
    expect(current_path).to eq signup_path
    expect(page).to have_content "Password confirmation no puede estar en blanco"
  end

  xscenario "when password  is not match" do
    visit signup_path
    fill_in 'user_email', with: Faker::Internet.email
    fill_in 'user_password', with: Faker::Internet.password
    fill_in 'user_password_confirmation', with: Faker::Internet.password

    click_button 'Crear cuenta'
    expect(current_path).to eq signup_path
    expect(page).to have_content "Password confirmation no coincide"
  end
end
