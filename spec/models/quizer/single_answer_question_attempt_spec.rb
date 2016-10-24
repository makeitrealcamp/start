require 'rails_helper'

RSpec.describe Quizer::SingleAnswerQuestionAttempt, type: :model do

  context 'associations' do
    it { should belong_to(:quiz_attempt) }
    it { should belong_to(:question) }
  end

  it "has a valid factory" do
    question_attempt = build(:single_answer_question_attempt)
    expect(question_attempt).to be_valid
  end

  describe "validations" do
    it "validates data schema" do
      question_attempt = build(:single_answer_question_attempt)
      expect(question_attempt).to receive(:validate_data_schema)
      question_attempt.save
    end
  end

  it "calculates and assigns score before save" do
    question_attempt = build(:single_answer_question_attempt)
    expect(question_attempt).to receive(:calculate_score)
    question_attempt.save
  end

  it "assigns a score before_save" do
    question_attempt = build(:single_answer_question_attempt)
    question_attempt.save
    expect(question_attempt.reload.score).to_not be_nil
  end

  describe ".score" do
    it "is 1 if the answer is correct" do
      question_attempt = build(:single_answer_question_attempt)
      question_attempt.answer = SHA1.encode(question_attempt.question.answer)
      question_attempt.save
      expect(question_attempt.score).to eq(1)
    end

    it "is 0 if the answer is incorrect" do
      question_attempt = build(:single_answer_question_attempt)
      question_attempt.answer = SHA1.encode(question_attempt.question.wrong_answers.first)
      question_attempt.save
      expect(question_attempt.score).to eq(0)
    end
  end
end
