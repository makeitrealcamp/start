# encoding: UTF-8
require "rails_helper"

RSpec.feature "Sign Up", type: :feature do
  scenario "when user is logged in" do
    login(create(:user))
    visit signup_path
    expect(current_path).to eq signed_in_root_path
  end

  scenario "with valid attributes" do
    visit signup_path
    fill_in 'user_email', with: Faker::Internet.email
    password  = Faker::Internet.password
    fill_in 'user_password', with: password
    fill_in 'user_password_confirmation', with: password
    click_button 'Empezar'
    expect(current_path).to eq signed_in_root_path
  end

  scenario "execute analytics script after sign up", js: true do
    visit signup_path
    fill_in 'user_email', with: Faker::Internet.email
    password  = Faker::Internet.password
    fill_in 'user_password', with: password
    fill_in 'user_password_confirmation', with: password
    click_button 'Empezar'

    expect(current_path).to eq signed_in_root_path
    analyticsMock = page.evaluate_script('window.analyticsMock');
    expect(analyticsMock).to eq(true)
  end

  scenario "not execute analytics script when user is active", js: true do
    login(create(:user,status: :active,last_active_at: Time.now))

    visit signed_in_root_path

    analyticsMock = page.evaluate_script('window.analyticsMock');
    expect(analyticsMock).to eq(false)
  end

  scenario "with invalid email" do
    visit signup_path
    fill_in 'user_email', with: 'invalid'
    fill_in 'user_password', with: Faker::Internet.password
    click_button 'Empezar'

    expect(current_path).to eq signup_path
    expect(page).to have_content "Email no es válido"
  end

  scenario "with existing email" do
    user = create(:user)

    visit signup_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: Faker::Internet.password
    click_button 'Empezar'

    expect(current_path).to eq signup_path
    expect(page).to have_content "Email ya está en uso"
  end

  scenario "with no password" do
    visit signup_path
    fill_in 'user_email', with: Faker::Internet.email
    click_button 'Empezar'

    expect(current_path).to eq signup_path
    expect(page).to have_content "Password no puede estar en blanco"
  end

  scenario "with no password confirmation" do
    visit signup_path
    fill_in 'user_email', with: Faker::Internet.email
    fill_in 'user_password', with: Faker::Internet.password
    click_button 'Empezar'
    expect(current_path).to eq signup_path
    expect(page).to have_content "Password confirmation no puede estar en blanco"
  end

  scenario "when password  is not match" do
    visit signup_path
    fill_in 'user_email', with: Faker::Internet.email
    fill_in 'user_password', with: Faker::Internet.password
    fill_in 'user_password_confirmation', with: Faker::Internet.password

    click_button 'Empezar'
    expect(current_path).to eq signup_path
    expect(page).to have_content "Password confirmation no coincide"
  end
end
