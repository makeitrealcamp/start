require 'rails_helper'

RSpec.feature "Quizzes", type: :feature do
  let(:user) { create(:user) }
  let(:subject) { create(:subject) }

  scenario "lists published quizzes" do
    create(:quiz, subject: subject, published: true)
    create(:quiz, subject: subject, published: false)

    login(user)

    visit subject_path(subject)
    click_link "Quizzes"

    expect(page).to have_selector('.quiz', count: 1)
    expect(page).to have_no_css('.actions') # shouldn't show buttons to edit and delete quiz
  end

  scenario "shows a quiz" do
    quiz = create(:quiz, subject: subject, published: true)

    login(user)

    visit subject_path(subject)
    click_link "Quizzes"

    click_link quiz.name

    expect(page).to have_no_css("a.btn.btn-info")
    expect(current_path).to eq subject_quizer_quiz_path(subject, quiz)
  end

  scenario "attempts a quiz" do
    quiz = create(:quiz, subject: subject)

    login(user)

    visit subject_path(subject)
    click_link "Quizzes"
    expect(page).to have_content(quiz.name)

    click_link quiz.name
    click_button 'Comenzar Quiz'

    attempt = quiz.quiz_attempts.last
    expect(current_path).to eq subject_quizer_quiz_quiz_attempt_path(subject, quiz, attempt)
  end
end
