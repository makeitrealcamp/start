require 'rails_helper'

RSpec.feature "Challenges", type: :feature do

  let!(:user)      { create(:user) }
  let!(:admin )    { create(:admin) }
  let!(:course)    { create(:course) }
  let!(:challenge) { create(:challenge, course: course, published: true, restricted: true) }

  context 'when user is free account' do
    context 'should not access challenges restricted' do
      scenario 'return not found when access by url' do
        login(user)
        expect{ visit course_challenge_path(course, challenge) }.to raise_error ActionController::RoutingError
      end

      scenario 'list only the challenges free', js: true do
        create(:challenge, course: course, published: true)
        create(:challenge, course: course, published: true)
        login(user)
        visit course_path(course)
        wait_for_ajax
        expect(Challenge.where(restricted: false).count).to eq 2
        expect(page).to have_selector('.challenge', count: 2)
        expect(page).to have_selector('.alert-info')
      end
    end
  end

  context 'when user is paid account' do
    scenario 'list challenges published', js: true do
      user = create(:user, account_type: User.account_types[:paid_account])
      create(:challenge, course: course, published: true)
      create(:challenge, course: course, published: true)
      login(user)
      visit course_path(course)
      wait_for_ajax
      expect(page).to have_selector('.challenge', count: 3)
      expect(page).not_to have_selector('.alert-info')
    end
  end
end
