# == Schema Information
#
# Table name: quiz_attempts
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  quiz_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_quiz_attempts_on_quiz_id  (quiz_id)
#  index_quiz_attempts_on_user_id  (user_id)
#

require 'rails_helper'

RSpec.describe Quiz::QuizAttempt, type: :model do
  it "has a valid factory" do
    quiz_attempt = build(:quiz_attempt)
    expect(quiz_attempt).to be_valid
  end
end
