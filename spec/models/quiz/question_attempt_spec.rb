# == Schema Information
#
# Table name: question_attempts
#
#  id              :integer          not null, primary key
#  quiz_attempt_id :integer
#  question_id     :integer
#  data            :json
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  type            :string
#
# Indexes
#
#  index_question_attempts_on_question_id      (question_id)
#  index_question_attempts_on_quiz_attempt_id  (quiz_attempt_id)
#

require 'rails_helper'

RSpec.describe Quiz::QuestionAttempt, type: :model do

  it "has a valid factory" do
    question_attempt = build(:multi_answer_question_attempt)
    expect(question_attempt).to be_valid
  end

  describe "validations" do
    it "validates data schema" do
      question_attempt = Quiz::MultiAnswerQuestionAttempt.create
      expect(question_attempt.errors).to have_key(:data)
    end
  end

end
