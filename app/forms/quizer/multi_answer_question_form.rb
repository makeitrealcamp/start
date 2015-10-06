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
