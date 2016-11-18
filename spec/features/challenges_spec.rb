require 'rails_helper'

RSpec.feature "Challenges", type: :feature do
  let!(:user)         { create(:user_with_path) }
  let!(:path)         { user.paths.first }
  let!(:phase)        { create(:phase, path: path) }
  let!(:subject)       { create(:subject) }
  let!(:course_phase) { create(:course_phase, subject: subject, phase: phase) }
  let!(:challenge)    { create(:challenge, subject: subject, published: true, restricted: true) }
  let!(:level_1)      { create(:level, required_points: 100) }
  let!(:level_2)      { create(:level, required_points: 200) }

  scenario "accepts challenge" do
    login(user)

    visit subject_challenge_path(subject, challenge)
    click_link '¡Sí, empezar a trabajar!'

    expect(page).not_to have_link '¡Sí, empezar a trabajar!'
    solution = user.solutions.where(challenge_id: challenge.id).take
    expect(solution).to_not be_nil
  end

  scenario "resets solution", js: true do
    create(:solution, user: user, challenge: challenge)

    login(user)

    visit subject_challenge_path(subject, challenge)
    find('.nav-tabs .dropdown-toggle').click
    click_link 'Reiniciar Reto'
    page.driver.browser.switch_to.alert.accept
    wait_for_ajax

    expect(current_path).to eq subject_challenge_path(subject, challenge)
  end

  scenario "deletes challenge", js: true do
    admin = create(:admin)
    create(:challenge, subject: subject, published: true)
    create(:challenge, subject: subject, published: true)

    login(admin)

    visit subject_path(subject)
    all(:css, '.actions a .glyphicon.glyphicon-remove').first.click
    page.driver.browser.switch_to.alert.accept

    expect(page).to have_selector('.challenge', count: 2)
    expect(Challenge.count).to eq 2
  end

  scenario "preview challenge", js: true do
    challenge.update(preview: true)
    solution = create(:solution, user: user, challenge: challenge, status: :created)
    document = solution.documents.create(name: 'index.html')

    login(user)
    visit subject_challenge_path(subject, challenge)

    new_window = window_opened_by { click_link "Preview" }
    within_window new_window do
      expect(page.current_path).to eq(preview_solution_path(id: solution.id, file: document.name))
    end
    new_window.close
  end
end
