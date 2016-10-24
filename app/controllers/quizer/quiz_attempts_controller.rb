module Quizer
  class QuizAttemptsController < ApplicationController
    include ResourcesHelper

    before_action :private_access
    before_action :set_subject
    before_action :set_quiz
    before_action :set_quiz_attempt, only: [:show,:finish,:results]

    def show
    end

    def create
      @quiz_attempt = @quiz.quiz_attempts.create!(user: current_user)
      redirect_to next_subject_resource_quiz_attempt_question_attempts_path(@subject, @quiz, @quiz_attempt.reload)
    end

    def reset
      if @quiz.is_being_attempted_by_user?(current_user)
        quiz_attempt = current_user.quiz_attempts.ongoing.find_by_quiz_id(@quiz.id)
        quiz_attempt.cancelled!
      end

      @quiz_attempt = @quiz.quiz_attempts.create(user: current_user)
      redirect_to next_subject_resource_quiz_attempt_question_attempts_path(@subject, @quiz, @quiz_attempt.reload)
    end

    def finish
      @quiz_attempt.finished!
      redirect_to results_subject_resource_quiz_attempt_path(@quiz_attempt.quiz.subject, @quiz_attempt.quiz, @quiz_attempt)
    end

    def results
      
    end

    private
      def set_subject
        @subject = Subject.friendly.find(params[:subject_id])
      end

      def set_quiz
        @quiz = Quiz.friendly.find(params[:resource_id])
      end

      def set_quiz_attempt
        @quiz_attempt = QuizAttempt.find(params[:id])
      end
  end
end
