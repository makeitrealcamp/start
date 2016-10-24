require 'rails_helper'

RSpec.feature "QuizAttempts", type: :feature do
  let!(:user) { create(:user) }
  let!(:subject) { create(:subject) }
  let!(:quiz) { create(:quiz, subject: subject, published: true) }
  let!(:multi_answer_question) { create(:multi_answer_question, quiz: quiz, published: true) }
  let!(:open_question) { create(:open_question, quiz: quiz, published: true) }
  let!(:quiz_attempt) { create(:quiz_attempt, quiz: quiz, user: user) }

  context 'when the quiz attempt has  been finished', js: true do
    scenario 'display results' do
      quiz_attempt.finished!
      login(user)
      wait_for_ajax
      visit results_subject_resource_quiz_attempt_path(subject, quiz, quiz_attempt)
      expect(current_path).to eq results_subject_resource_quiz_attempt_path(subject, quiz, quiz_attempt)
    end
  end
end
