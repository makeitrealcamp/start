require 'rails_helper'

RSpec.describe Quizer::BooleanQuestionAttemptForm do
  it "saves form with false option" do
    question_attempt = create(:boolean_question_attempt)
    form = question_attempt.new_form({ answer: false })
    assert form.save

    question_attempt.reload
    refute question_attempt.answer
  end
end
