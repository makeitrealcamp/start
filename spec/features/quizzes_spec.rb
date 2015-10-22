require 'rails_helper'

RSpec.feature "Quizzes", type: :feature do
  let!(:user) { create(:paid_user) }
  let!(:admin) { create(:admin) }
  let!(:course) { create(:course) }
  let!(:quiz) { create(:quiz, course: course, published: true) }
  let!(:quiz_attempt){ create(:quiz_attempt, quiz: quiz, user: user) }


  context 'when not accessed as user' do
    scenario 'not display show quiz' do
      visit course_quizer_quiz_path(course, quiz)
      expect(current_path).to eq login_path
    end

    scenario 'not display the quiz attempt' do
      visit course_quizer_quiz_path(course, quiz)
      expect(current_path).to eq login_path
    end

    scenario 'not display results quiz' do
      visit results_course_quizer_quiz_quiz_attempt_path(course, quiz, quiz_attempt)
      expect(current_path).to eq login_path
    end
  end

  context 'when accessed as user' do
    scenario "list all quizzes published", js: true do
      create(:quiz, course: course, published: true)
      create(:quiz, course: course, published: false)
      login(user)
      wait_for_ajax
      visit course_path(course)
      find("a", text: "Quizzes").click
      expect(page).to have_selector('.quiz', count: 2)
      #no show buttons edit and delete quiz
      expect(page).to have_no_css('.actions')
    end

    scenario 'display quiz', js: true do
      login(user)
      wait_for_ajax
      visit course_path(course)
      find("a", text: "Quizzes").click
      click_link quiz.name
      expect(current_path).to eq course_quizer_quiz_path(course, quiz)
      expect(page).to have_no_css("a.btn.btn-info")
    end

    scenario 'should not show the form of add questions to quiz' do
      login(user)
      expect{visit course_quizer_quiz_questions_path(course, quiz)}.to raise_error ActionController::RoutingError
    end

    scenario 'should not show form edit quiz' do
      login(user)
      expect{visit edit_course_quizer_quiz_path(course, quiz)}.to raise_error ActionController::RoutingError
    end

    scenario 'should not show form new quiz' do
      login(user)
      expect{visit new_course_quizer_quiz_path(course)}.to raise_error ActionController::RoutingError
    end

    context 'when has not Started the quiz', js: true do
      scenario 'should create attempt' do
        quiz = create(:quiz, course: course, published: true)
        login(user)
        wait_for_ajax
        visit course_path(course)
        find("a", text: "Quizzes").click
        click_link quiz.name
        click_button 'Comenzar Quiz'
        attempt = quiz.quiz_attempts.last
        expect(current_path).to eq course_quizer_quiz_quiz_attempt_path(course, quiz, attempt)
      end
    end

    context 'when has Started the quiz', js: true do
      scenario 'should continue the attempt' do
        login(user)
        wait_for_ajax
        visit course_path(course)
        find("a", text: "Quizzes").click
        click_link quiz.name
        click_link "Continuar Quiz"
        expect(current_path).to eq course_quizer_quiz_quiz_attempt_path(course, quiz, quiz_attempt)
      end
    end

    context 'when the quiz has finished', js: true do
      scenario 'display score' do
        quiz_attempt.finished!
        login(user)
        wait_for_ajax
        visit course_path(course)
        find("a", text: "Quizzes").click
        expect(page).to have_css(".score-box", count: 1)
      end
    end
  end

  context 'when accessed as admin', js: true do
    scenario 'list all quizzes' do
      create(:quiz, course: course, published: true)
      create(:quiz, course: course, published: false)
      login(admin)
      wait_for_ajax
      visit course_path(course)
      find("a", text: "Quizzes").click
      expect(page).to have_selector('.quiz', count: 3)
      #show buttons edit and delete quiz
      expect(page).to have_css('.actions')
    end

    scenario 'display form new quiz' do
      login(admin)
      wait_for_ajax
      visit course_path(course)
      find("a", text: "Quizzes").click
      click_link 'Nuevo Quiz'
      expect(current_path).to eq new_course_quizer_quiz_path(course)
      expect(page).to have_content('Nuevo Quiz')
      expect(page).to have_select('quizer_quiz_course_id', selected: course.name)
    end

    context 'when create quiz' do
      scenario 'with valid input' do
        login(admin)
        wait_for_ajax
        visit new_course_quizer_quiz_path(course)
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

      scenario 'without valid input' do
        login(admin)
        wait_for_ajax
        visit new_course_quizer_quiz_path(course)
        click_button 'Crear Quiz'
        expect(page).to have_selector ".alert-error"
      end
    end

    scenario 'display form edit quiz' do
      login(admin)
      wait_for_ajax
      visit course_path(course)
      find("a", text: "Quizzes").click
      all(".quizzes span.action-edit").first.click
      expect(current_path).to eq edit_course_quizer_quiz_path(course, quiz)
      expect(page).to have_content('Editar Quiz')
    end

    context 'when update quiz' do
      scenario 'with valid input' do
        login(admin)
        wait_for_ajax
        visit edit_course_quizer_quiz_path(course, quiz)
        name = Faker::Name::title
        fill_in 'quizer_quiz_name', with: name
        find(:css, "#quizer_quiz_published").set(false)
        click_button 'Actualizar Quiz'
        quiz.reload
        expect(quiz.name).to eq name
        expect(quiz.published?).to eq false
      end

      scenario 'without valid input' do
        login(admin)
        wait_for_ajax
        visit edit_course_quizer_quiz_path(course, quiz)
        fill_in 'quizer_quiz_name', with: nil
        find(:css, "#quizer_quiz_published").set(false)
        click_button 'Actualizar Quiz'
        expect(page).to have_selector ".alert-error"
      end
    end
  end
end
