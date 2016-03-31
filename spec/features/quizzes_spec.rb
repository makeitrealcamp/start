require 'rails_helper'

RSpec.feature "Quizzes", type: :feature do
  let(:user) { create(:user) }
  let(:course) { create(:course) }

  scenario "lists published quizzes" do
    create(:quiz, course: course, published: true)
    create(:quiz, course: course, published: false)

    login(user)
    
    visit course_path(course)
    click_link "Quizzes"

    expect(page).to have_selector('.quiz', count: 1)
    expect(page).to have_no_css('.actions') # shouldn't show buttons to edit and delete quiz
  end

  scenario "shows a quiz" do
    quiz = create(:quiz, course: course, published: true)

    login(user)
    
    visit course_path(course)
    click_link "Quizzes"
    
    click_link quiz.name

    expect(page).to have_no_css("a.btn.btn-info")
    expect(current_path).to eq course_quizer_quiz_path(course, quiz)
  end

  scenario "attempts a quiz" do
    quiz = create(:quiz, course: course)
    
    login(user)
    
    visit course_path(course)
    click_link "Quizzes"
    expect(page).to have_content(quiz.name)

    click_link quiz.name
    click_button 'Comenzar Quiz'

    attempt = quiz.quiz_attempts.last
    expect(current_path).to eq course_quizer_quiz_quiz_attempt_path(course, quiz, attempt)
  end
end
