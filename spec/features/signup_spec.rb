# encoding: UTF-8
require "rails_helper"

RSpec.feature "Sign Up", type: :feature do
  scenario "with valid attributes" do
    visit signup_path
    fill_in 'user_email', with: Faker::Internet.email
    fill_in 'user_password', with: Faker::Internet.password
    click_button 'Empezar'

    expect(current_path).to eq courses_path
  end

  scenario "with invalid email" do
    visit signup_path
    fill_in 'user_email', with: 'invalid'
    fill_in 'user_password', with: Faker::Internet.password
    click_button 'Empezar'

    expect(current_path).to eq signup_path
    expect(page).to have_content "Email no es válido"
  end

  scenario "with no password" do
    visit signup_path
    fill_in 'user_email', with: 'invalid'
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
end