module Quizer
  class SingleAnswerQuestionForm < BaseForm

    attribute :question, SingleAnswerQuestion
    attribute :answer, String
    attribute :wrong_answers, Array
    attribute :text, String
    attribute :published, Boolean
    attribute :explanation, String

    validates :text, presence: true
    validates :question, presence: true
    validate :validate_at_least_one_answer

    def self.sanitize_params(params)
      params
        .require(:question)
        .permit(:text, :published, :explanation, :answer, wrong_answers: [])
    end

    def initialize(question_or_attributes)
      if question_or_attributes.is_a? Quizer::Question
        super(
          question: question_or_attributes,
          text: question_or_attributes.text,
          published: question_or_attributes.published,
          explanation: question_or_attributes.explanation,
          answer: question_or_attributes.answer,
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
          "answer" => @answer,
          "wrong_answers" => @wrong_answers.reject(&:empty?)
        }

        @question.update!(published: @published, explanation: @explanation, data: new_data)
      end

      def answers
        a = @wrong_answers.reject(&:empty?)
        a << @answer
        a
      end

      def validate_at_least_one_answer
        if answers.length == 0
          errors[:answers] << "Debe existir por lo menos una respuesta"
        end
      end
  end
end
