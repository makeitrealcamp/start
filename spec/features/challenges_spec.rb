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
        visit course_challenge_path(course, challenge)
        expect(current_path).to eq signed_in_root_path
        expect(page).to have_selector('.alert-top-notice', count: 1)
        expect(page).to have_content('Debes estar inscrito al programa para acceder a este recurso')
      end
    end

    context 'list challenges' do
      scenario 'only the published' do
        create(:challenge, course: course, published: true)
        create(:challenge, course: course, published: false)
        login(user)
        visit course_path(course)
        expect(page).to have_selector('.challenge', count: 2)
        expect(page).to have_selector('.banner')
      end

      scenario 'view' do
        create(:challenge, course: course, published: true, restricted: false)
        create(:challenge, course: course, published: true, restricted: false)
        login(user)
        visit course_path(course)
        expect(page).to have_selector(".glyphicon-lock", count: 1)
        expect(page).to have_selector(".glyphicon-ok", count: 2)
      end

      scenario 'disabled challenge when is restricted' do
        login(user)
        visit course_path(course)
        all(:css, '.challenge').first.click
        expect(current_path).to eq course_path(course)
      end

      scenario 'enabled challenge when is not restricted', js: true do
        free_challenge = create(:challenge, course: course, published: true, restricted: false)
        login(user)
        visit course_path(course)
        click_on free_challenge.name
        expect(current_path).to eq course_challenge_path(course, free_challenge)
      end
    end
  end

  context 'when user is paid account' do
    context 'list challenges' do
      scenario 'only the published' do
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
