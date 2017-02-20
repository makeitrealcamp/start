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

RSpec.describe Quizer::SingleAnswerQuestion, type: :model do
  context 'associations' do
    it { should belong_to(:quiz) }
  end

  it "has a valid factory" do
    question = build(:single_answer_question)
    expect(question).to be_valid
  end

  describe "validations" do
    it "validates data schema" do
      question = Quizer::SingleAnswerQuestion.create(data: {})
      expect(question.errors).to have_key(:data)
    end
  end

  describe ".mixed_answers" do
    it "returns answer and wrong answers" do
      question = build(:single_answer_question)
      mixed_answers = question.mixed_answers

      expect(mixed_answers.length).to eq(4)
      expect(mixed_answers).to include("10")
      expect(mixed_answers).to include("20")
      expect(mixed_answers).to include("30")
      expect(mixed_answers).to include("5")
    end
  end

  describe ".wrong_answers" do
    it "returns wrong answers" do
      question = build(:single_answer_question)
      wrong_answers = question.wrong_answers

      expect(wrong_answers.length).to eq(3)
      expect(wrong_answers).to include("20")
      expect(wrong_answers).to include("30")
      expect(wrong_answers).to include("5")
    end
  end
end
