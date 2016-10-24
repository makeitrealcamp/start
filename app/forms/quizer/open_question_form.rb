module Quizer
  class OpenQuestionForm < BaseForm

    attribute :question, OpenQuestion
    attribute :text, String
    attribute :correct_answer, String
    attribute :published, Boolean
    attribute :explanation, String

    validates :question, presence: true
    validates :text, presence: true
    validates :correct_answer, presence: true

    def self.sanitize_params(params)
      params
        .require(:question)
        .permit(:text, :published, :explanation, :correct_answer)
    end

    def initialize(question_or_attributes)
      if question_or_attributes.is_a? Quizer::Question
        super(
          question: question_or_attributes,
          text: question_or_attributes.text,
          published: question_or_attributes.published,
          explanation: question_or_attributes.explanation,
          correct_answer: question_or_attributes.correct_answer
        )
      else
        super(question_or_attributes)
      end
    end



    private

      def persist!
        new_data = {
          "text" => @text,
          "correct_answer" => @correct_answer
        }
        @question.update!(published: @published, explanation: @explanation, data: new_data )
      end
  end
end
