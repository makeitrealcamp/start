# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  quiz_id    :integer
#  type       :string
#  data       :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  published  :boolean
#
# Indexes
#
#  index_questions_on_quiz_id  (quiz_id)
#

require 'rails_helper'

RSpec.describe Quizer::Question, type: :model do

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

end
