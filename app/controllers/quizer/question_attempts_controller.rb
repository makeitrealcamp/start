module Quizer
  class QuestionAttemptsController < ApplicationController
    before_action :set_course
    before_action :set_quiz
    before_action :set_quiz_attempt
    before_action :set_question_attempt, only: [:update]

    def update
      form = MultiAnswerQuestionAttemptForm.new(
        question_attempt_params.merge(question_attempt: @question_attempt)
      )
      if form.save
        head :ok
      else
        head :internal_server_error
      end
    end

    private
      def question_attempt_params
        params
          .require(:question_attempt)
          .permit(answers:[])
      end

      def set_course
        @course = Course.friendly.find(params[:course_id])
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
