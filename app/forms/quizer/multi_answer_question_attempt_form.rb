module Quizer
  class MultiAnswerQuestionAttemptForm < BaseForm

    attribute :answers, Array
    attribute :question_attempt, MultiAnswerQuestionAttempt


    validates :answers, presence: true
    validates :question_attempt, presence: true

    private

      def persist!
        old_data = @question_attempt.data || {}
        new_data = old_data.merge({"answers" => @answers.reject(&:empty?)})
        @question_attempt.update!(data: new_data )
      end

  end
end
