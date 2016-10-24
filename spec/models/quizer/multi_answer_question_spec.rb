# == Schema Information
#
# Table name: questions
#
#  id          :integer          not null, primary key
#  quiz_id     :integer
#  type        :string
#  data        :json
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  published   :boolean
#  explanation :text
#
# Indexes
#
#  index_questions_on_quiz_id  (quiz_id)
#

require 'rails_helper'

RSpec.describe Quizer::MultiAnswerQuestion, type: :model do
  context 'associations' do
    it { should belong_to(:quiz) }
  end

  it "has a valid factory" do
    question = build(:multi_answer_question)
    expect(question).to be_valid
  end

  describe "validations" do
    it "validates data schema" do
      question = Quizer::MultiAnswerQuestion.create(data:{})
      expect(question.errors).to have_key(:data)
    end
  end

  describe ".mixed_answers" do
    it "returns correct and wrong answers" do
      question = build(:multi_answer_question)
      mixed_answers = question.mixed_answers

      expect(mixed_answers.length).to eq(5)
      expect(mixed_answers).to include("wrong answer a")
      expect(mixed_answers).to include("wrong answer b")
      expect(mixed_answers).to include("wrong answer c")
      expect(mixed_answers).to include("correct answer d")
      expect(mixed_answers).to include("correct answer e")
    end
  end

  describe ".correct_answers" do
    it "returns the correct answers" do
      question = build(:multi_answer_question)
      correct_answers = question.correct_answers

      expect(correct_answers.length).to eq(2)

      expect(correct_answers).to include("correct answer d")
      expect(correct_answers).to include("correct answer e")
    end
  end

  describe ".wrong_answers" do
    it "returns the wrong answers" do
      question = build(:multi_answer_question)
      wrong_answers = question.wrong_answers

      expect(wrong_answers.length).to eq(3)

      expect(wrong_answers).to include("wrong answer a")
      expect(wrong_answers).to include("wrong answer b")
      expect(wrong_answers).to include("wrong answer c")
    end
  end

end
