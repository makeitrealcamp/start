require 'rails_helper'

RSpec.feature "Quizzes", type: :feature do
  let(:admin) { create(:admin) }
  let(:subject) { create(:subject) }

  scenario "lists all quizzes" do
    create(:quiz, subject: subject, title: "Quiz 1", published: true)
    create(:quiz, subject: subject, title: "Quiz 2", published: false)

    login(admin)

    visit subject_path(subject)
    click_link "Recursos"

    expect(page).to have_content("Quiz 1")
    expect(page).to_not have_content("Quiz 2")
    expect(page).to have_css('.actions') # shows buttons to edit and delete
  end

  scenario "creates a quiz" do
    login(admin)

    visit new_subject_resource_path(subject)

    title = Faker::Name.title
    expect {
      fill_in 'resource_title', with: title
      fill_in 'resource_description', with: Faker::Lorem.paragraph
      select "Quiz", from: 'resource_type'
      find(:css, "#resource_published").set(true)
      click_button 'Crear Resource'
    }.to change(Quizer::Quiz, :count).by 1

    quiz = Quizer::Quiz.last
    expect(quiz.title).to eq title
    expect(quiz.published?).to eq true
  end

  scenario "updates a quiz" do
    quiz = create(:quiz, subject: subject)

    login(admin)

    visit edit_subject_resource_path(subject, quiz)

    title = Faker::Name::title
    fill_in 'resource_title', with: title
    find(:css, "#resource_published").set(false)
    click_button 'Actualizar Resource'

    quiz.reload
    expect(quiz.title).to eq  title
    expect(quiz.published?).to eq false
  end
end
