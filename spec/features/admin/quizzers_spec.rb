require 'rails_helper'

RSpec.feature "Quizzes", type: :feature do
  let(:admin) { create(:admin) }
  let(:subject) { create(:subject) }

  scenario "lists all quizzes" do
    create(:quiz, subject: subject, published: true)
    create(:quiz, subject: subject, published: false)

    login(admin)

    visit subject_path(subject)
    click_link "Quizzes"

    expect(page).to have_selector('.quiz', count: 2)
    expect(page).to have_css('.actions') # shows buttons to edit and delete
  end

  scenario "creates a quiz" do
    login(admin)

    visit new_subject_quizer_quiz_path(subject)

    name = Faker::Name.title
    expect {
      fill_in 'quizer_quiz_name', with: name
      find(:css, "#quizer_quiz_published").set(true)
      click_button 'Crear Quiz'
    }.to change(Quizer::Quiz, :count).by 1

    quiz = Quizer::Quiz.last
    expect(quiz.name).to eq name
    expect(quiz.published?).to eq true
  end

  scenario "updates a quiz" do
    quiz = create(:quiz, subject: subject)

    login(admin)

    visit edit_subject_quizer_quiz_path(subject, quiz)

    name = Faker::Name::title
    fill_in 'quizer_quiz_name', with: name
    find(:css, "#quizer_quiz_published").set(false)
    click_button 'Actualizar Quiz'

    quiz.reload
    expect(quiz.name).to eq name
    expect(quiz.published?).to eq false
  end
end
