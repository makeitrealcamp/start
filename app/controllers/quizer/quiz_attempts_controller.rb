module Quizer
  class QuizAttemptsController < ApplicationController
    before_action :set_course
    before_action :set_quiz
    before_action :set_quiz_attempt, only: [:show]

    def show
    end

    def create
      @quiz_attempt = @quiz.quiz_attempts.new(user: current_user)
      if @quiz_attempt.save
        redirect_to course_quiz_quiz_quiz_attempt_path(@course,@quiz,@quiz_attempt)
      else
        byebug
        flash[:error] = "Algo salió mal"
        redirect_to :back
      end
    end

    private
      def set_course
        @course = Course.friendly.find(params[:course_id])
      end

      def set_quiz
        @quiz = Quiz.friendly.find(params[:quiz_id])
      end

      def set_quiz_attempt
        @quiz_attempt = QuizAttempt.find(params[:id])
      end
  end
end
