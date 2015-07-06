require 'rails_helper'

RSpec.feature "Challenges", type: :feature do

  let!(:user)      { create(:user) }
  let!(:user_paid) {create(:user, account_type: User.account_types[:paid_account]) }
  let!(:admin )    { create(:admin) }
  let!(:course)    { create(:course) }
  let!(:challenge) { create(:challenge, course: course, published: true, restricted: true) }

  context 'when user is free account' do
    context 'should not access challenges restricted' do
      scenario 'return not found when access by url' do
        login(user)
        expect{ visit course_challenge_path(course, challenge) }.to raise_error ActionController::RoutingError
      end
    end
  end

  context 'when user is paid account' do
    scenario 'list challenges published', js: true do
      create(:challenge, course: course, published: true)
      create(:challenge, course: course, published: true)
      login(user_paid)
      visit course_path(course)
      wait_for_ajax
      expect(page).to have_selector('.challenge', count: 3)
      expect(page).not_to have_selector('.alert-info')
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
