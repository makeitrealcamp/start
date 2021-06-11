require 'rails_helper'

RSpec.feature "Question management", type: :feature do
  let(:admin) { create(:admin_user) }
  let(:subject) { create(:subject) }
  let(:quiz) { create(:quiz, subject: subject) }

  scenario "lists questions of a quiz" do
    create_list(:open_question, 3, quiz: quiz)

    login(admin)
    visit subject_resource_path(subject, quiz)

    click_link 'Editar preguntas'
    expect(current_path).to eq subject_resource_questions_path(subject, quiz)
  end

  scenario "creates a question", js: true do
    login(admin)
    visit subject_resource_questions_path(subject, quiz)

    question = 'why?'
    answer_correct = 'answer correct 1'
    wrong_answer = 'wrong answer 1'
    select "Respuesta Múltiple", from: 'type'
    click_button 'Agregar Pregunta'
    fill_in 'question_text', with: question

    find(:css, '.add-correct-answer').click
    within all('.correct-answers .answer').first do
      find('textarea').set(answer_correct)
    end

    find(:css, '.add-wrong-answer').click
    within all('.wrong-answers .answer').first do
      find('textarea').set(wrong_answer)
    end

    click_button 'Guardar'
    expect(page).to have_no_css('#question-modal')

    quiz_question = quiz.questions.last
    expect(quiz_question.data["text"]).to eq question
    expect(quiz_question.data["correct_answers"][0]).to eq answer_correct
    expect(quiz_question.data["wrong_answers"][0]).to eq wrong_answer
  end

  scenario "updates a question", js: true do
    question = create(:open_question, quiz: quiz)

    login(admin)

    visit subject_resource_questions_path(subject, quiz)
    find(:css, "tr#question-#{question.id} a span.glyphicon-pencil").click
    expect(page).to have_selector('#question-modal')

    text = 'what?'
    answer = 'answer correct'
    fill_in 'question_text', with: text
    fill_in 'question_correct_answer', with: answer
    click_button 'Guardar'

    expect(page).to have_no_css('#question-modal')

    question.reload
    expect(question.data["text"]).to eq text
    expect(question.data["correct_answer"]).to eq answer
  end
end
