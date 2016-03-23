# == Schema Information
#
# Table name: challenge_completions
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  challenge_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_challenge_completions_on_challenge_id  (challenge_id)
#  index_challenge_completions_on_user_id       (user_id)
#

require 'rails_helper'

RSpec.describe ChallengeCompletion, type: :model do
  context "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:challenge) }
  end

  context "validations" do
    it { should validate_presence_of :user }
    it { should validate_presence_of :challenge }
  end

  it "has a valid factory" do
    expect(build(:challenge_completion)).to be_valid
  end
end
