require 'rails_helper'

RSpec.feature "Questions", type: :feature do
  let!(:user) { create(:paid_user) }
  let!(:admin) { create(:admin) }
  let!(:course) { create(:course) }
  let!(:quiz) { create(:quiz, course: course, published: true) }
  let!(:multi_answer_question){ create(:multi_answer_question, quiz: quiz, published: true) }
  let!(:open_question){ create(:open_question, quiz: quiz, published: true) }
  let!(:quiz_attempt){ create(:quiz_attempt, quiz: quiz, user: user) }

  context 'when accessed as user' do
    scenario 'should no show list all questions' do
      login(user)
      expect{visit course_quizer_quiz_questions_path(course, quiz)}.to raise_error ActionController::RoutingError
    end
  end

  context 'when accessed as admin' do
    scenario 'list all questions of a quiz', js: true do
      login(admin)
      visit course_quizer_quiz_path(course, quiz)
      click_link 'Preguntas'
      expect(current_path).to eq course_quizer_quiz_questions_path(course, quiz)
    end

    context 'when is multiple answers questions', js: true do
      scenario 'display modal form' do
        login(admin)
        visit course_quizer_quiz_questions_path(course, quiz)
        click_button 'Agregar Pregunta'
        expect(page).to have_css('#question-modal')
        expect(page).to have_css('button.add-correct-answer')
        expect(page).to have_css('button.add-wrong-answer')
      end

      context 'when create question' do
        scenario 'with 1 answer correct and 1 wrong answer' do
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
          wait_for_ajax

          quiz_question = quiz.questions.last
          expect(page).to have_no_css('#question-modal')
          expect(quiz_question.data["text"]).to eq question
          expect(quiz_question.data["correct_answers"][0]).to eq answer_correct
          expect(quiz_question.data["wrong_answers"][0]).to eq wrong_answer
        end

        scenario 'with multiple correct answers and multiple wrong answers' do
          login(admin)
          visit course_quizer_quiz_questions_path(course, quiz)

          question = 'why?'
          answer_correct1 = 'answer correct 1'
          answer_correct2 = 'answer correct 2'
          wrong_answer1 = 'wrong answer 1'
          wrong_answer2 = 'wrong answer 1'

          click_button 'Agregar Pregunta'
          fill_in 'question_text', with: question

          #Add answers correct
          find(:css, '.add-correct-answer').click
          within all('.correct-answers .answer').first do
            find('textarea').set(answer_correct1)
          end

          find(:css, '.add-correct-answer').click
          within all('.correct-answers .answer').last do
            find('textarea').set(answer_correct2)
          end

          #Add wrong answers
          find(:css, '.add-wrong-answer').click
          within all('.wrong-answers .answer').first do
            find('textarea').set(wrong_answer1)
          end

          find(:css, '.add-wrong-answer').click
          within all('.wrong-answers .answer').last do
            find('textarea').set(wrong_answer2)
          end

          click_button 'Guardar'
          wait_for_ajax

          quiz_question = quiz.questions.last
          expect(page).to have_no_css('#question-modal')
          expect(quiz_question.data["text"]).to eq question
          expect(quiz_question.data["correct_answers"][0]).to eq answer_correct1
          expect(quiz_question.data["correct_answers"][1]).to eq answer_correct2
          expect(quiz_question.data["wrong_answers"][0]).to eq wrong_answer1
          expect(quiz_question.data["wrong_answers"][1]).to eq wrong_answer2
        end

        scenario 'without valid input' do
          login(admin)
          visit course_quizer_quiz_questions_path(course, quiz)
          click_button 'Agregar Pregunta'
          click_button 'Guardar'
          wait_for_ajax
          within :css, '#question-modal' do
            expect(page).to have_css '.alert-error'
          end
        end
      end

      context 'when update question' do
        scenario 'display modal form' do
          login(admin)
          visit course_quizer_quiz_questions_path(course, quiz)
          all(:css, 'a span.glyphicon-pencil').first.click
          expect(page).to have_css('#question-modal')
          expect(page).to have_css(".correct-answers .answer textarea", count: 2)
          expect(page).to have_css(".wrong-answers .answer textarea", count: 3)
        end

        scenario 'with add new answers' do
          login(admin)
          visit course_quizer_quiz_questions_path(course, quiz)
          question = 'when?'
          answer_correct = 'other answer correct'
          wrong_answer = 'other wrong answer'
          all(:css, 'a span.glyphicon-pencil').first.click
          fill_in 'question_text', with: question

          #Add new answers
          find(:css, '.add-correct-answer').click
          within all('.correct-answers .answer').last do
            find('textarea').set(answer_correct)
          end

          find(:css, '.add-wrong-answer').click
          within all('.wrong-answers .answer').last do
            find('textarea').set(wrong_answer)
          end

          click_button 'Guardar'
          wait_for_ajax
          quiz_question = quiz.questions.first
          expect(page).to have_no_css('#question-modal')
          expect(quiz_question.data["text"]).to eq question
          expect(quiz_question.data["correct_answers"][2]).to eq answer_correct
          expect(quiz_question.data["wrong_answers"][3]).to eq wrong_answer
        end

        scenario 'with remove answers correct' do
          login(admin)
          visit course_quizer_quiz_questions_path(course, quiz)
          all(:css, 'a span.glyphicon-pencil').first.click
          wait_for_ajax
          expect(page).to have_selector('.correct-answers .answer')
          within all('.correct-answers .answer').last do
            find('.remove-answer').click
          end

          wait_for_ajax

          within all('.wrong-answers .answer').last do
            find('.remove-answer').click
          end

          click_button 'Guardar'
          wait_for_ajax
          quiz_question = quiz.questions.first
          expect(quiz_question.data["correct_answers"].count).to eq 1
          expect(quiz_question.data["wrong_answers"].count).to eq 2
        end

        scenario 'without valid input' do
          login(admin)
          visit course_quizer_quiz_questions_path(course, quiz)
          all(:css, 'a span.glyphicon-pencil').first.click
          fill_in 'question_text', with: nil
          click_button 'Guardar'
          wait_for_ajax
          within :css, '#question-modal' do
            expect(page).to have_css '.alert-error'
          end
        end
      end
    end

    context 'when is open questions', js: true do
      scenario 'display modal form' do
        login(admin)
        visit course_quizer_quiz_questions_path(course, quiz)
        select 'Quizer::OpenQuestion', from: "type"
        click_button 'Agregar Pregunta'
        expect(page).to have_css('#question-modal')
        expect(page).to have_css('form.new_question')
        expect(page).to have_css('#question_correct_answer')
      end

      context 'when create question' do
        scenario 'with valid input' do
          login(admin)
          question = 'why?'
          answer = 'answer correct'
          visit course_quizer_quiz_questions_path(course, quiz)
          select 'Quizer::OpenQuestion', from: "type"
          click_button 'Agregar Pregunta'
          fill_in 'question_text', with: question
          fill_in 'question_correct_answer', with: answer
          click_button 'Guardar'
          wait_for_ajax
          quiz_question = quiz.questions.last
          expect(page).to have_no_css('#question-modal')
          expect(quiz_question.data["text"]).to eq question
          expect(quiz_question.data["correct_answer"]).to eq answer
        end

        scenario 'without valid input' do
          login(admin)
          visit course_quizer_quiz_questions_path(course, quiz)
          select 'Quizer::OpenQuestion', from: "type"
          click_button 'Agregar Pregunta'
          click_button 'Guardar'
          wait_for_ajax
          within :css, '#question-modal' do
            expect(page).to have_css '.alert-error'
          end
        end
      end

      context 'when update question' do
        scenario 'with valid input' do
          login(admin)
          visit course_quizer_quiz_questions_path(course, quiz)
          question = 'what?'
          answer = 'answer correct'
          all(:css, 'a span.glyphicon-pencil').last.click
          fill_in 'question_text', with: question
          fill_in 'question_correct_answer', with: answer
          click_button 'Guardar'
          wait_for_ajax
          quiz_question = quiz.questions.last
          expect(page).to have_no_css('#question-modal')
          expect(quiz_question.data["text"]).to eq question
          expect(quiz_question.data["correct_answer"]).to eq answer
        end

        scenario 'without valid input' do
          login(admin)
          visit course_quizer_quiz_questions_path(course, quiz)
          question = 'what?'
          answer = 'answer correct'
          all(:css, 'a span.glyphicon-pencil').last.click
          fill_in 'question_text', with: nil
          fill_in 'question_correct_answer', with: nil
          click_button 'Guardar'
          wait_for_ajax
          within :css, '#question-modal' do
            expect(page).to have_css '.alert-error'
          end
        end
      end
    end
  end
end
