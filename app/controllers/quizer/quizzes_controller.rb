module Quizer
  class QuizzesController < ApplicationController
    before_action :set_course
    before_action :set_quiz, only: [:destroy,:update,:edit,:show]

    def show
      @finished_quiz_attempts = current_user.quiz_attempts
        .where(quiz_id: @quiz.id).finished.order('created_at DESC')
    end

    def new
      @quiz = @course.quizzes.build
    end

    def create
      @quiz = Quiz.new(quiz_params)
      if @quiz.save
        flash[:notice] = "Quiz creado"
        redirect_to course_path(@quiz.course)
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @quiz.update(quiz_params)
        flash[:notice] = "Quiz actualizado"
        redirect_to course_path(@quiz.course)
      else
        render :edit
      end
    end

    def destroy
      @quiz.destroy
      head :ok
    end

    def update_position
      @quiz = Quiz.update(params[:id], row_position: params[:position])
      head :ok
    end

    private
      def quiz_params
        params.require(:quiz_quiz).permit(:name, :published,:course_id)
      end

      def set_course
        @course = Course.friendly.find(params[:course_id])
      end

      def set_quiz
        @quiz = Quiz.friendly.find(params[:id])
      end
  end
end
