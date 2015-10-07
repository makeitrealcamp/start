require 'rails_helper'

RSpec.feature "QuizAttempts", type: :feature do
  let!(:user) { create(:paid_user) }
  let!(:course) { create(:course) }
  let!(:quiz) { create(:quiz, course: course) }
  let!(:quiz_attempt){ create(:quiz_attempt, quiz: quiz, user: user) }

  context 'when the quiz is being attempted', js: true do
    scenario 'not display results' do
      login(user)
      visit results_course_quizer_quiz_quiz_attempt_path(course, quiz, quiz_attempt)
      expect(current_path).to eq course_quizer_quiz_quiz_attempt_path(course, quiz, quiz_attempt)
    end
  end

  context 'when the quiz attempt has  been finished', js: true do
    scenario 'display results' do
      quiz_attempt.finished!
      login(user)
      visit results_course_quizer_quiz_quiz_attempt_path(course, quiz, quiz_attempt)
      expect(current_path).to eq results_course_quizer_quiz_quiz_attempt_path(course, quiz, quiz_attempt)
    end
  end


end
