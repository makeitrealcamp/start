# == Schema Information
#
# Table name: quiz_attempts
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  quiz_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  status           :integer
#  score            :decimal(, )
#  current_question :integer          default(0)
#
# Indexes
#
#  index_quiz_attempts_on_quiz_id  (quiz_id)
#  index_quiz_attempts_on_user_id  (user_id)
#

require 'rails_helper'

RSpec.describe Quizer::QuizAttempt, type: :model do
  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:quiz) }
    it { should have_many(:question_attempts) }
    it { should have_many(:questions) }
  end

  it "has a valid factory" do
    expect(build(:quiz_attempt)).to be_valid
  end

  describe ".create" do
    let(:quiz_attempt) { create(:quiz_attempt, status: :ongoing) }

    it "doesn't allow to create more than one ongoing quiz attempt for the same quiz and user" do
      invalid_quiz_attempt = build(:quiz_attempt,
        user: quiz_attempt.user,quiz: quiz_attempt.quiz,
        status: Quizer::QuizAttempt.statuses[:ongoing]
      )
      expect(invalid_quiz_attempt).to_not be_valid
      expect(invalid_quiz_attempt.errors).to have_key(:user)
    end

    it "allows to create a quiz attempt if there are no ongoing quizzes_attempts" do
      quiz_attempt.finished!
      other_quiz_attempt = build(:quiz_attempt,
        user: quiz_attempt.user,quiz: quiz_attempt.quiz,
        status: Quizer::QuizAttempt.statuses[:ongoing]
      )
      expect(other_quiz_attempt).to be_valid
    end
  end

  describe ".score" do
    let(:quiz_attempt) { create(:quiz_attempt, status: :ongoing) }
    let(:question_attempts) { build_list(:question_attempt, 10, quiz_attempt: quiz_attempt) }

    it "returns 1 if all the questions attempts have score 1" do
      question_attempts.each do |q|
        expect(q).to receive(:calculate_score).and_return(1.0)
        q.save!
      end
      expect(quiz_attempt.score).to eq(1.0)
    end

    it "returns 0 if all the questions attempts have score 0" do
      question_attempts.each do |q|
        expect(q).to receive(:calculate_score).and_return(0.0)
        q.save!
      end
      expect(quiz_attempt.score).to eq(0.0)
    end

    it "returns the average of the scores of the question attempts" do
      scores = (0...10).map { rand }
      scores_avg = scores.sum/scores.length.to_f
      question_attempts.each_with_index do |q,i|
        expect(q).to receive(:calculate_score).and_return(scores[i])
        q.save!
      end
      expect(quiz_attempt.score).to be_within(0.001).of(scores_avg)
    end
  end

  describe ".log_activity" do
    it "logs the activity on create" do
      expect { create(:quiz_attempt) }.to change(ActivityLog, :count).by(1)
    end

    it "logs the activity on finish" do
      quiz_attempt = create(:quiz_attempt)
      expect { quiz_attempt.finished! }.to change(ActivityLog, :count).by(1)
    end
  end
end
