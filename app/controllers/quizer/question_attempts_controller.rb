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
      form.save

      if @quiz_attempt.is_last_question?
        @quiz_attempt.finished!
        redirect_to results_subject_resource_quiz_attempt_path(@quiz_attempt.quiz.subject, @quiz_attempt.quiz, @quiz_attempt)
      else
        @quiz_attempt.next_question!
        redirect_to next_subject_resource_quiz_attempt_question_attempts_path(@subject, @quiz, @quiz_attempt)
      end
    end

    def next
      @question_attempt = @quiz_attempt.current_question_attempt
    end

    private
      def set_subject
        @subject = Subject.friendly.find(params[:subject_id])
      end

      def set_quiz
        @quiz = Quiz.friendly.find(params[:resource_id])
      end

      def set_quiz_attempt
        @quiz_attempt = QuizAttempt.find(params[:quiz_attempt_id])
      end

      def set_question_attempt
        @question_attempt = QuestionAttempt.find(params[:id])
      end
  end
end
