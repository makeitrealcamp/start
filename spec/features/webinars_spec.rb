require 'rails_helper'

RSpec.feature "Webinars", type: :feature do
  include ActiveJob::TestHelper

  scenario "user can list, register and watch webinar", js: true do
    ActionMailer::Base.deliveries.clear

    upcoming = create(:webinar, :upcoming)
    past = create(:webinar, :past)

    visit webinars_path

    expect(page).to have_css(".webinars-upcoming #webinar-#{upcoming.id}")
    expect(page).to have_css(".webinars-past #webinar-#{past.id}")

    click_link upcoming.title

    expect(current_path).to eq webinar_path(id: upcoming.slug)

    expect {
      fill_in 'webinars_participant_email', with: "pedro@example.com"
      fill_in 'webinars_participant_first_name', with: "Pedro"
      fill_in 'webinars_participant_last_name', with: "Perez"
      click_button 'REGISTRARSE'
      expect(page).to have_css('.rsvp-icon')
    }.to change(Webinars::Participant, :count).by 1

    email = ActionMailer::Base.deliveries.last
    expect(email).to_not be_nil

    participant = upcoming.participants.where(email: "pedro@example.com").take
    expect(email.body.raw_source).to include(attend_webinar_path(id: upcoming.slug, token: participant.token))
    expect(email.body.raw_source).to include(calendar_webinar_path(id: upcoming.slug, token: participant.token))

    # watch webinar
    visit webinars_path
    click_link past.title

    expect(current_path).to eq webinar_path(id: past.slug)
    expect(page).to have_content("VER AHORA")

    fill_in 'webinars_participant_email', with: "maria@example.com"
    fill_in 'webinars_participant_first_name', with: "Maria"
    fill_in 'webinars_participant_last_name', with: "Gomez"
    click_button 'VER AHORA'
    expect(page).to have_css('.rsvp-icon')

    participant = past.participants.where(email: "maria@example.com").take
    expect(participant).to_not be_nil

    email = ActionMailer::Base.deliveries.last
    expect(email.body.raw_source).to include(watch_webinar_path(id: past.slug, token: participant.token))
  end
end
