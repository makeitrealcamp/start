module Quizer
  class QuestionAttemptsController < ApplicationController
    before_action :set_subject
    before_action :set_quiz
    before_action :set_quiz_attempt
    before_action :set_question_attempt, only: [:update]

    def update
      form = @question_attempt.new_form(
        @question_attempt.form_type.sanitize_params(params)
      )
      if form.save
        head :ok
      else
        head :internal_server_error
      end
    end

    private

      def set_subject
        @subject = Subject.friendly.find(params[:subject_id])
      end

      def set_quiz
        @quiz = Quiz.friendly.find(params[:quiz_id])
      end

      def set_quiz_attempt
        @quiz_attempt = QuizAttempt.find(params[:quiz_attempt_id])
      end

      def set_question_attempt
        @question_attempt = QuestionAttempt.find(params[:id])
      end
  end
end
