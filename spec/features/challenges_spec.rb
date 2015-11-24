require 'rails_helper'

RSpec.feature "Challenges", type: :feature do

  let!(:user)         { create(:user) }
  let!(:user_paid)    { create(:user, account_type: User.account_types[:paid_account]) }
  let!(:admin )       { create(:admin) }
  let!(:path)         { user_paid.paths.first }
  let!(:phase)        { path.phases.first }
  let!(:course)       { create(:course) }
  let!(:course_phase) { create(:course_phase,course: course, phase: phase) }
  let!(:challenge)    { create(:challenge, course: course, published: true, restricted: true) }
  let!(:level_1)      { create(:level_1) }
  let!(:level_2)      { create(:level_2) }

  context 'user with paid account' do
    describe 'list challenges' do
      scenario 'show only published challenges' do
        create(:challenge, course: course, published: true)
        create(:challenge, course: course, published: false)
        login(user_paid)
        visit course_path(course)
        expect(page).to have_selector('.challenge', count: 2)
        expect(page).not_to have_selector('.banner')
      end

      scenario 'view' do
        create(:challenge, course: course, published: true, restricted: false)
        create(:challenge, course: course, published: true, restricted: false)
        login(user_paid)
        visit course_path(course)
        expect(page).to have_selector(".glyphicon-ok", count: 3)
      end

      scenario 'enabled challenge when is restricted', js: true do
        login(user_paid)
        visit course_path(course)
        all(:css, '.challenge').first.click
        wait_for_ajax
        expect(current_path).to eq course_challenge_path(course, challenge)
      end
    end
  end

  context 'when user is admin' do
    context 'list challenges' do
      scenario 'list all the challenges' do
        create(:challenge, course: course, published: true)
        create(:challenge, course: course, published: false)
        login(admin)
        visit course_path(course)
        expect(page).to have_selector('.challenge', count: 3)
        expect(page).not_to have_selector('.banner')
      end

      scenario 'view' do
        create(:challenge, course: course, published: true, restricted: false)
        create(:challenge, course: course, published: true, restricted: true)
        login(user_paid)
        visit course_path(course)
        expect(page).to have_selector(".challenge .actions", count: 3)
      end
    end
  end

  scenario 'reset solution', js: true do
    create(:solution, user: user_paid, challenge: challenge)
    login(user_paid)
    visit course_challenge_path(course, challenge)
    find('.nav-tabs .dropdown-toggle').click
    click_link 'Reiniciar Reto'
    page.driver.browser.switch_to.alert.accept
    wait_for_ajax
    course_challenge_path(course, challenge)
  end

  context 'accept challenge' do
    scenario 'when have not accepted the challenge' do
      login(user_paid)
      visit course_challenge_path(course, challenge)
      expect(page).to have_link '¡Sí, empezar a trabajar!'
    end

    scenario 'when accept challenge', js: true do
      login(user_paid)
      visit course_challenge_path(course, challenge)
      click_link '¡Sí, empezar a trabajar!'
      expect(page).not_to have_link '¡Sí, empezar a trabajar!'
      solution = user_paid.solutions.where(challenge_id: challenge.id).take
      expect(solution)
    end
  end

  context 'delete challenge', js: true do
    scenario 'without solutions' do
      create(:challenge, course: course, published: true)
      create(:challenge, course: course, published: true)
      login(admin)
      visit course_path(course)
      all(:css, '.actions a .glyphicon.glyphicon-remove').first.click
      page.driver.browser.switch_to.alert.accept
      wait_for_ajax
      expect(page).to have_selector('.challenge', count: 2)
      expect(Challenge.count).to eq 2
    end
  end

end
