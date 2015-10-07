module Quizer
  module QuestionsHelper
    def question_form_path(question_form,query={})
      if question_form.question.new_record?
        course_quizer_quiz_questions_path(
          question_form.question.quiz.course,
          question_form.question.quiz,
          query
        )
      else
        course_quizer_quiz_question_path(
          question_form.question.quiz.course,
          question_form.question.quiz,
          question_form.question,
          query
        )
      end
    end

    def question_type_options
      options_for_select(Quizer::Question.types.map{ |t| [t.name,t.name] })
    end
  end
end
