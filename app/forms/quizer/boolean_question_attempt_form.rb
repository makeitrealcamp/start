class Quizer::BooleanQuestionAttemptForm < BaseForm
  attribute :answer, Boolean
  attribute :question_attempt, Quizer::BooleanQuestionAttempt

  validates :answer, inclusion: [true, false]
  validates :question_attempt, presence: true

  def initialize(attempt_or_attributes)
    if attempt_or_attributes.is_a? Quizer::QuestionAttempt
      puts "#{attempt_or_attributes}****************"
      super(
        question_attempt: attempt_or_attributes,
        answer: attempt_or_attributes.answer
      )
    else
      super(attempt_or_attributes)
    end
  end

  def self.sanitize_params(params)
    params.require(:question_attempt).permit(:answer)
  end

  private

    def persist!
      old_data = @question_attempt.data || {}
      new_data = old_data.merge({ "answer" => @answer })
      @question_attempt.update!(data: new_data)
    end

end
