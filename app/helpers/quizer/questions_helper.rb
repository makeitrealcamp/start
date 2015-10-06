module Quizer
  module QuestionsHelper
    def question_form_path(question_form)
      if question_form.question.new_record?
        course_quizer_quiz_questions_path(
          question_form.question.quiz.course,
          question_form.question.quiz
        )
      else
        course_quizer_quiz_question_path(
          question_form.question.quiz.course,
          question_form.question.quiz,
          question_form.question
        )
      end
    end
  end
end
