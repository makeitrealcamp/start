require 'rails_helper'

RSpec.feature "Challenges management", type: :feature do
  let!(:admin)   { create(:admin) }


  scenario "creates a challenge", js: true do
    user = create(:user_with_path)
    challenge = create(:challenge, subject: create(:subject_with_phase))
                create(:challenge, :challenge_page)
    login(admin)

    visit(admin_challenges_path)

      find('.challenge-new').click

      name = Faker::Name::name
      instructions = Faker::Lorem.paragraph
      solution_video = "https://www.youtube.com/embed/52Gg9CqhbP8"
      solution_text = Faker::Lorem.paragraph
      timeout = 15

        select challenge.subject.name, from: "challenge_subject_id"
        fill_in 'challenge_name', with: name
        select  20, from: "challenge_difficulty_bonus"
        fill_in 'challenge_instructions', with: instructions
        fill_in 'challenge_solution_video_url', with: solution_video
        fill_in 'challenge_solution_text', with: solution_text
        fill_in 'challenge_timeout', with: timeout
        find(:css, "#challenge_checkbox").click
        find('#challenge_evaluation_strategy').find(:option, "PhantomJS (Embedded Files)").select_option
        click_button 'Crear Reto'
  end

    scenario "edits a course", js: true do
      user = create(:user_with_path)
      challenge = create(:challenge, subject: create(:subject_with_phase))
                  create(:challenge, :challenge_page)
      login(admin)

      visit(admin_challenges_path)

      find('.edit-subject').click

      name = Faker::Name::name
      description = Faker::Lorem.paragraph
      excerpt = Faker::Lorem.paragraph
      time_estimate = 25

        fill_in 'subject_name', with: name
        fill_in 'subject_description', with: description
        fill_in 'subject_excerpt', with: excerpt
        fill_in 'subject_time_estimate', with: time_estimate
        select   Subject.second, from: "subject_phase_id"
        find('.glyphicon-trash').click
        find('.glyphicon-plus').click
        find(:css, "#subject_checkbox").click
        click_button 'Actualizar Subject'
    end

  scenario "edits a challenge", js: true do
    user = create(:user_with_path)
    challenge = create(:challenge, subject: create(:subject_with_phase))
                create(:challenge, :challenge_page)
    login(admin)

    visit(admin_challenges_path)

    find('.action-edit').click

    name = Faker::Name::name
    instructions = Faker::Lorem.paragraph
    solution_video = "https://www.youtube.com/embed/52Gg9CqhbP8"
    solution_text = Faker::Lorem.paragraph
    timeout = 15

      select challenge.subject.name, from: "challenge_subject_id"
      fill_in 'challenge_name', with: name
      byebug
      select  20, from: "challenge_difficulty_bonus"
      fill_in 'challenge_instructions', with: instructions
      fill_in 'challenge_solution_video_url', with: solution_video
      fill_in 'challenge_solution_text', with: solution_text
      fill_in 'challenge_timeout', with: timeout
      find(:css, "#challenge_checkbox").click
      find('#challenge_evaluation_strategy').find(:option, "PhantomJS (Embedded Files)").select_option
      click_button 'Editar Reto'

    expect(current_path).to eq  admin_challenges_path

    challenge.reload
    expect(challenge.name).to eq name
    expect(challenge.instructions).to eq instructions
    expect(challenge.solution_video_url).to eq solution_video_url
  end

  scenario "deletes a challenge", js: true do
    user = create(:user_with_path)
    challenge = create(:challenge, subject: create(:subject_with_phase))
                create(:challenge, :challenge_page)

    login(admin)

    visit (admin_challenges_path)

    find('.glyphicon-remove').click
    page.driver.browser.switch_to.alert.accept
    wait_for_ajax

    expect(Challenge.count).to eq 1
  end
end
