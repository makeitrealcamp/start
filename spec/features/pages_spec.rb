require 'rails_helper'

RSpec.feature "Pages", type: :feature do

  scenario "sign up to front end online program", js: true do
    ActionMailer::Base.deliveries.clear
    visit front_end_online_path

    fill_in "first-name", with: "Pedro"
    fill_in "last-name", with: "Perez"
    fill_in "email", with: "lead@example.com"
    select "Colombia", from: 'country'
    expect(page).to have_selector '#mobile'
    fill_in "mobile", with: "3131234567"

    find('button[type="submit"]').click

    expect(current_path).to eq thanks_front_end_online_path

    expect(ActionMailer::Base.deliveries.count).to eq 1
    email = ActionMailer::Base.deliveries.first
    expect(email.to).to include "carolina.hernandez@makeitreal.camp"
    expect(email.subject).to include "[Nuevo Lead Front End Online]"
  end

  scenario "sign up to full stack online program", js: true do
    ActionMailer::Base.deliveries.clear
    visit full_stack_online_path

    fill_in "first-name", with: "Pedro"
    fill_in "last-name", with: "Perez"
    fill_in "email", with: "lead@example.com"
    select "Colombia", from: 'country'
    expect(page).to have_selector '#mobile'
    fill_in "mobile", with: "3131234567"

    find('button[type="submit"]').click

    expect(current_path).to eq thanks_full_stack_online_path

    expect(ActionMailer::Base.deliveries.count).to eq 1
    email = ActionMailer::Base.deliveries.first
    expect(email.to).to include "carolina.hernandez@makeitreal.camp"
    expect(email.subject).to include "[Nuevo Lead Full Stack Online]"
  end

  scenario "attemp to buy react-redux course with deposit", js: true do
    ActionMailer::Base.deliveries.clear
    visit cursos_react_redux_path

    first('.btn-register').click

    expect(page).to have_selector '#registration-modal'

    fill_in "first-name", with: "Pedro"
    fill_in "last-name", with: "Perez"
    fill_in "email", with: "lead@example.com"
    choose("Transferencia o depósito")

    click_button "Continuar"

    expect(page).to have_selector '.step-3'

    fill_in "customer-id", with: "1234567"
    select "Colombia", from: 'country'
    fill_in "mobile", with: "123456789"
    fill_in "invoice-address", with: "Cll 12 # 13 - 25"
    click_button "FINALIZAR"

    charge = Billing::Charge.last
    expect(charge).to_not be_falsy

    expect(current_path).to eq billing_charge_path(id: charge.uid)
  end
end
