module Quizer
  class MultiAnswerQuestionForm < BaseForm

    attribute :question, MultiAnswerQuestion
    attribute :correct_answers, Array
    attribute :wrong_answers, Array
    attribute :text, String
    attribute :published, Boolean

    validates :text, presence: true
    validates :question, presence: true
    validate :validate_at_least_one_answer

    def self.sanitize_params(params)
      params
        .require(:question)
        .permit(:text,:published,correct_answers:[],wrong_answers:[])
    end
    
    def initialize(question_or_attributes)
      if question_or_attributes.is_a? Quizer::Question
        super(
          question: question_or_attributes,
          text: question_or_attributes.text,
          published: question_or_attributes.published,
          correct_answers: question_or_attributes.correct_answers,
          wrong_answers: question_or_attributes.wrong_answers
        )
      else
        super(question_or_attributes)
      end
    end


    private

      def persist!
        new_data = {
          "text" => @text,
          "correct_answers" => @correct_answers.reject(&:empty?),
          "wrong_answers" => @wrong_answers.reject(&:empty?)
        }

        @question.update!(published: @published,data: new_data )
      end

      def answers
        @correct_answers.reject(&:empty?) + @wrong_answers.reject(&:empty?)
      end

      def validate_at_least_one_answer
        if answers.length == 0
          errors[:answers] << "Debe haber por lo menos una respuesta"
        end
      end
  end
end
