require 'rails_helper'

RSpec.feature "Question management", type: :feature do
  let(:admin) { create(:admin) }
  let(:course) { create(:course) }
  let(:quiz) { create(:quiz, course: course) }

  scenario "lists questions of a quiz" do
    create_list(:open_question, 3, quiz: quiz)

    login(admin)
    visit course_quizer_quiz_path(course, quiz)

    click_link 'Preguntas'
    expect(current_path).to eq course_quizer_quiz_questions_path(course, quiz)
  end

  scenario "creates a question", js: true do
    login(admin)
    visit course_quizer_quiz_questions_path(course, quiz)
    
    question = 'why?'
    answer_correct = 'answer correct 1'
    wrong_answer = 'wrong answer 1'
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

    visit course_quizer_quiz_questions_path(course, quiz)
    find(:css, "tr#question-#{question.id} a span.glyphicon-pencil").click
    wait_for_ajax

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