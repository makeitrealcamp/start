module Quizer
  class QuizAttemptsController < ApplicationController
    include QuizzesHelper

    before_action :set_course
    before_action :set_quiz
    before_action :set_quiz_attempt, only: [:show,:finish,:results]

    def show
    end

    def create
      if @quiz.is_being_attempted_by_user?(current_user)
        redirect_to ongoing_quiz_attempt_for_user_path(@quiz,current_user)
      elsif @quiz_attempt = @quiz.quiz_attempts.create(user: current_user)
        redirect_to course_quizer_quiz_quiz_attempt_path(@course,@quiz,@quiz_attempt.reload)
      else
        flash[:error] = "Algo salió mal"
        redirect_to :back
      end
    end

    def finish
      @quiz_attempt.finished!
      redirect_to quiz_attempt_results_path(@quiz_attempt)
    end

    def results
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
