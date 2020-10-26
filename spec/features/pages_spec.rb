require 'rails_helper'

RSpec.feature "Pages", type: :feature do
  include ActiveJob::TestHelper

  scenario "sign up to full stack online program", js: true do
    ActionMailer::Base.deliveries.clear
    visit full_stack_online_path

    first('button.btn-register').click
    expect(page).to have_css("#registration-modal")

    within :css, "#registration-modal" do
      fill_in "first-name", with: "Pedro"
      fill_in "last-name", with: "Perez"
      fill_in "email", with: "lead@example.com"
      select "Google", from: "source"

      find('button[type="submit"]').click
    end

    expect(current_path).to eq thanks_full_stack_online_path
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
    select "Google", from: "source"

    find('button[type="submit"]').click

    expect(current_path).to eq thanks_data_science_online_path
    expect(CreateLeadJob).to have_been_enqueued
  end

  scenario "apply to the top program", js: true do
    visit  "/top"

    first('button.apply-now-btn').click
    expect(page).to have_css("#application-modal")

    sleep 0.5 # hack to wait for the animations of the modal
    find('#terms').click
    find('.next[type="button"]').click

    fill_in "first-name", with: "Pedro"
    fill_in "last-name", with: "Perez"
    fill_in "email", with: "lead@example.com"
    fill_in "birthday", with: "12/05/2016"
    select "Otro", from: 'gender'
    select "Colombia", from: 'country'
    expect(page).to have_selector '#mobile'
    fill_in "mobile", with: "3131234567"
    fill_in "applicant[url]", with: "www.davidcillo.com"
    find('#payment-method').find('option[value="scheme-1"]').select_option

    find('.next[type="button"]').click
    fill_in "goal", with: "mi motivación es aprender"
    fill_in "experience", with: "1 año"
    fill_in "additional", with: "me gustan los animales"
    find('.finish[type="button"]').click

    expect(current_path).to eq thanks_top_path
  end

  scenario "apply to the women scholarship", js: true do
    ActionMailer::Base.deliveries.clear
    visit full_stack_online_becas_mujeres_path

    first('button.btn-register').click
    expect(page).to have_css("#registration-modal")

    fill_in "first-name", with: "Maria"
    fill_in "last-name", with: "Gomez"
    fill_in "email", with: "maria@example.com"
    fill_in "age", with: "20"
    fill_in "application_reason", with: "Me parece muy interesante"
    fill_in "url", with: "https://example.com/"
    select "YouTube", from: "source"

    find('button[type="submit"]').click

    expect(current_path).to eq thanks_fs_becas_mujeres_path
    expect(ConvertLoopJob).to have_been_enqueued
  end

end
