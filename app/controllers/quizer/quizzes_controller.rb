module Quizer
  class QuizzesController < ApplicationController
    before_action :private_access
    before_action :admin_access, except: [:show]
    before_action :set_subject, except: [:update_position]
    before_action :set_quiz, only: [:destroy,:update,:edit,:show]

    def show
      @finished_quiz_attempts = current_user.quiz_attempts
        .where(quiz_id: @quiz.id).finished.order('created_at DESC')
    end

    def new
      @quiz = @subject.quizzes.build
    end

    def create
      @quiz = Quizer::Quiz.new(quiz_params)
      if @quiz.save
        flash[:notice] = "Quiz creado"
        redirect_to subject_path(@quiz.subject,anchor: "quizzes")
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @quiz.update(quiz_params)
        flash[:notice] = "Quiz actualizado"
        redirect_to subject_path(@quiz.subject,anchor: "quizzes")
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
        params.require(:quizer_quiz).permit(:name, :published,:subject_id)
      end

      def set_subject
        @subject = Subject.friendly.find(params[:subject_id])
      end

      def set_quiz
        @quiz = Quiz.friendly.find(params[:id])
      end
  end
end
