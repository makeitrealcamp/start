module Quizer
  class QuestionsController < ApplicationController
    before_action :admin_access

    before_action :set_subject
    before_action :set_quiz
    before_action :set_question, only: [:update,:edit]

    def index
      @questions = @quiz.questions
    end

    def new
      @question = Quizer::Question.new(type: params[:type],quiz: @quiz)
      @question_form = @question.new_form
    end

    def create
      @question = Quizer::Question.new(type: params[:type],quiz: @quiz)
      @question_form = @question.new_form(@question.form_type.sanitize_params(params))
      @question_form.save
    end

    def edit
      @question_form = @question.new_form
    end

    def update
      @question_form = @question.new_form(@question.form_type.sanitize_params(params))
      @question_form.save
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

      def set_question
        @question = Question.find(params[:id])
      end
  end
end
