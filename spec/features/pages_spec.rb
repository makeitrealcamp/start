require 'rails_helper'

RSpec.feature "Pages", type: :feature do
  include ActiveJob::TestHelper

  scenario "sign up to rails program", js: true do
    ActionMailer::Base.deliveries.clear
    visit ruby_on_rails_path

    first('button.btn-register').click
    expect(page).to have_css("#registration-modal")

    within :css, "#registration-modal" do
      fill_in "first-name", with: "Pedro"
      fill_in "last-name", with: "Perez"
      fill_in "email", with: "lead@example.com"
      fill_in "mobile", with: "3111234567"
      fill_in "birthday", with: "09/01/1998"
      select "Hombre", from: "gender"  
      select "Google", from: "source"

      find('button[type="submit"]').click
    end

    expect(current_path).to eq thanks_ruby_on_rails_path
    expect(CreateLeadJob).to have_been_enqueued
  end

  scenario "sign up to agile tester program", js: true do
    ActionMailer::Base.deliveries.clear
    visit agile_tester_path

    first('button.btn-register').click
    expect(page).to have_css("#registration-modal")

    within :css, "#registration-modal" do
      fill_in "first-name", with: "Pedro"
      fill_in "last-name", with: "Perez"
      fill_in "email", with: "lead@example.com"
      fill_in "mobile", with: "3111234567"
      fill_in "birthday", with: "09/01/1998"
      select "Hombre", from: "gender"  
      select "Google", from: "source"

      find('button[type="submit"]').click
    end

    expect(current_path).to eq thanks_agile_tester_path
    expect(CreateLeadJob).to have_been_enqueued
  end

  scenario "sign up to data science program", js: true do
    ActionMailer::Base.deliveries.clear
    visit data_science_online_path

    first('button.btn-register').click
    expect(page).to have_css("#registration-modal")

    fill_in "first-name", with: "Pedro"
    fill_in "last-name", with: "Perez"
    fill_in "email", with: "lead@example.com"
    fill_in "mobile", with: "3111234567"
    fill_in "birthday", with: "09/01/1998"
    select "Hombre", from: "gender"  
    select "Google", from: "source"

    find('button[type="submit"]').click

    expect(current_path).to eq thanks_data_science_online_path
    expect(CreateLeadJob).to have_been_enqueued
  end

  scenario "apply to the top program", js: true do
    ActionMailer::Base.deliveries.clear
    visit  "/top"

    first('button.apply-now-btn').click
    expect(page).to have_css("#application-modal")

    sleep 0.5 # hack to wait for the animations of the modal
    find('#terms').click
    find('.accept-terms-btn[type="button"]').click
    
    fill_in "Email", with: "lead@example.com"
    find('.send-email-btn[type="submit"]').click
    expect(page).to have_css("#application-modal .verification-step")

    top_invitation = TopInvitation.where(email: "lead@example.com").take
    expect(top_invitation).not_to be_nil
    
    email = ActionMailer::Base.deliveries.last
    expect(email).to_not be_nil
    expect(email.body.raw_source).to include(top_invitation.token)

    fill_in "Token", with: "wrong token"
    find('.verification-btn[type="submit"]').click
    expect(page).to have_css("#application-modal .verification-step .form-group.has-error")

    fill_in "Token", with: top_invitation.token
    find('.verification-btn[type="submit"]').click

    expect(page).to have_css("#application-modal .application-1")
    fill_in "first-name", with: "Pedro"
    fill_in "last-name", with: "Perez"
    fill_in "birthday", with: "12/05/2016"
    select "Otro", from: 'gender'
    select "Colombia", from: 'country'
    expect(page).to have_selector '#mobile'
    fill_in "mobile", with: "3131234567"
    fill_in "applicant[url]", with: "www.davidcillo.com"
    find('#format').find('option[value="format-full"]').select_option
    find('#payment-method-fulltime').find('option[value="scheme-1"]').select_option
    find('#stipend').click

    find('.application-step-btn[type="button"]').click

    expect(page).to have_css("#application-modal .application-2")
    find('.submit[type="button"]').click
    expect(page).to have_css("#application-modal .application-2 .form-group.has-error")

    fill_in "goal", with: "mi motivación es aprender"
    fill_in "experience", with: "1 año"
    fill_in "additional", with: "me gustan los animales"
    find('.submit[type="button"]').click

    expect(current_path).to eq thanks_top_path

    top_invitation = TopInvitation.where(email: "lead@example.com").take
    expect(top_invitation).to be_nil
  end
end
