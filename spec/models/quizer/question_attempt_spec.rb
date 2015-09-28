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
#  score           :decimal(, )
#
# Indexes
#
#  index_question_attempts_on_question_id      (question_id)
#  index_question_attempts_on_quiz_attempt_id  (quiz_attempt_id)
#

require 'rails_helper'

RSpec.describe Quizer::QuestionAttempt, type: :model do

  it "has a valid factory" do
    question_attempt = build(:multi_answer_question_attempt)
    expect(question_attempt).to be_valid
  end

  describe "validations" do
    it "validates data schema" do
      question_attempt = build(:multi_answer_question_attempt)
      expect(question_attempt).to receive(:validate_data_schema)
      question_attempt.save
    end
  end

  describe "MultiAnswerQuestionAttempt" do

    let!(:quiz) { create(:quiz) }
    let!(:quiz_attempt) { create(:quiz_attempt, quiz: quiz) }
    let!(:question) { create(:multi_answer_question, quiz: quiz) }
    let!(:question_attempt) { create(:multi_answer_question_attempt, question: question, quiz_attempt: quiz_attempt) }

    describe "#score" do
      it "should call calculate_score before_save and assign a score" do
        multi_answer_question_attempt = build(:multi_answer_question_attempt)
        expect(multi_answer_question_attempt).to receive(:calculate_score)
        multi_answer_question_attempt.save
      end

      it "should assign a score before_save" do
        multi_answer_question_attempt = build(:multi_answer_question_attempt)
        multi_answer_question_attempt.save
        expect(multi_answer_question_attempt.reload.score).to_not be_nil
      end

      it "should be 1 if all the answers are correct" do
        question_attempt.data["answers"] = question.data["correct_answers"].shuffle
        question_attempt.save!
        question_attempt.reload
        expect(question_attempt.score).to eq(1)
      end

      it "should be 0 if all the answers are wrong" do
        question_attempt.data["answers"] = question.data["wrong_answers"].shuffle
        question_attempt.save!
        question_attempt.reload
        expect(question_attempt.score).to eq(0)
      end

      it "should always assign a score >= 0" do
        question.data["correct_answers"] = ["a","b","c"]
        question.data["wrong_answers"] = ["d","e"]
        question.save
        answers = question.mixed_answers
        # Generate all possible combinations of answers
        (0..answers.length).each do |i|
          answers.combination(i).each do |c|
            question_attempt.data["answers"] = c
            question_attempt.save
            expect(question_attempt.score).to be >= 0
          end
        end


      end

    end
  end
end
