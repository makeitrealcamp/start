module Quizer
  class QuestionsController < ApplicationController
    before_action :admin_access
    
    before_action :set_course
    before_action :set_quiz
    before_action :set_question, only: [:update,:edit]

    def index
      @questions = @quiz.questions
    end

    def new
      @question_form = Quizer::MultiAnswerQuestionForm.new
    end

    def create
      @question_form = Quizer::MultiAnswerQuestionForm.new(
        question_params
      )
      if @question_form.save
        flash[:notice] = "Pregunta creada"
        redirect_to course_quizer_quiz_questions_path
      else
        render :new
      end
    end

    def edit
      @question_form = Quizer::MultiAnswerQuestionForm.new(
        question: @question,
        text: @question.text,
        published: @question.published,
        correct_answers: @question.correct_answers,
        wrong_answers: @question.wrong_answers
      )
    end

    def update
      @question_form = MultiAnswerQuestionForm.new(
        question_params.merge(question: @question)
      )
      @question_form.save
    end

    private
      def question_params
        params
          .require(:question)
          .permit(:text,:published,correct_answers:[],wrong_answers:[])
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

      def set_question
        @question = Question.find(params[:id])
      end
  end
end
