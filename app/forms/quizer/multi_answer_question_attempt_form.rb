module Quizer
  class MultiAnswerQuestionAttemptForm < BaseForm

    attribute :answers, Array
    attribute :question_attempt, MultiAnswerQuestionAttempt


    validates :answers, presence: true
    validates :question_attempt, presence: true

    def initialize(attempt_or_attributes)
      if attempt_or_attributes.is_a? Quizer::QuestionAttempt
        super(
          question_attempt: attempt_or_attributes,
          answers: attempt_or_attributes.answers
        )
      else
        super(attempt_or_attributes)
      end
    end

    def self.sanitize_params(params)
      params
        .require(:question_attempt)
        .permit(answers:[])
    end

    private
      def persist!
        old_data = @question_attempt.data || {}
        new_data = old_data.merge({"answers" => @answers.reject(&:empty?)})
        @question_attempt.update!(data: new_data )
      end

  end
end
