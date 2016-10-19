require 'rails_helper'

RSpec.feature "QuizAttempts", type: :feature do
  let!(:user) { create(:user) }
  let!(:subject) { create(:subject) }
  let!(:quiz) { create(:quiz, subject: subject, published: true) }
  let!(:multi_answer_question){ create(:multi_answer_question, quiz: quiz, published: true) }
  let!(:open_question){ create(:open_question, quiz: quiz, published: true) }
  let!(:quiz_attempt){ create(:quiz_attempt, quiz: quiz, user: user) }

  scenario 'list only questions published', js: true do
    create(:multi_answer_question, quiz: quiz)
    login(user)
    wait_for_ajax
    visit subject_resource_quiz_attempt_path(subject, quiz, quiz_attempt)
    expect(page).to have_css('.row.question', count: 2)
  end

  context 'when the quiz is being attempted', js: true do
    scenario 'not display results' do
      login(user)
      wait_for_ajax
      visit results_subject_resource_quiz_attempt_path(subject, quiz, quiz_attempt)
      expect(current_path).to eq subject_resource_quiz_attempt_path(subject, quiz, quiz_attempt)
    end

    context 'when finalized the quiz' do
      scenario 'display result' do
        login(user)
        wait_for_ajax
        visit subject_path(subject)
        find("a", text: "Recursos").click
        click_link quiz.title
        click_link "Continuar Quiz"
        fill_in "question_attempt_answer", with: 10
        click_button 'Finalizar quiz y ver resultado'
        expect(current_path).to eq results_subject_resource_quiz_attempt_path(subject, quiz, quiz_attempt)
        expect(page).to have_css('span.text-success', count: 4)
        expect(page).to have_css('span.text-danger', count: 2)
      end
    end
  end

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
