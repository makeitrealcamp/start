module Quizer
  class QuizAttemptsController < ApplicationController
    include QuizzesHelper

    before_action :set_course
    before_action :set_quiz
    before_action :set_quiz_attempt, only: [:show,:finish,:results]

    def show
    end

    def create
      @quiz_attempt = @quiz.quiz_attempts.new(user: current_user)
      if @quiz_attempt.save
        redirect_to course_quizer_quiz_quiz_attempt_path(@course,@quiz,@quiz_attempt)
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
