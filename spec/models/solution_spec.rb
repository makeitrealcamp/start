# == Schema Information
#
# Table name: solutions
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  challenge_id :integer
#  status       :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  attempts     :integer
#  properties   :hstore
#
# Indexes
#
#  index_solutions_on_challenge_id  (challenge_id)
#  index_solutions_on_user_id       (user_id)
#  solutions_gin_properties         (properties)
#

require 'rails_helper'

RSpec.describe Solution, type: :model do

  let(:user) { create(:paid_user) }
  let(:challenge) { create(:challenge) }
  let(:solution) { create(:solution,challenge: challenge, user: user) }

  before do
    create(:level_1)
    create(:level_2)
  end

  describe "challenge completion" do
    context "User completes a challenge and creates the correct amount of points" do
      before do
        solution.update(status: Solution.statuses[:completed])
      end
      it "should create a challenge_completion after a challenge is completed for the first time" do
        expect(ChallengeCompletion.find_by_challenge_id(challenge.id)).to_not eq(nil)
      end

      it "should not create a challenge_completion after a challenge is completed for the second time" do
        solution.update(status: Solution.statuses[:failed])
        solution.update(status: Solution.statuses[:completed])
        expect(ChallengeCompletion.where(challenge_id: challenge.id).count).to eq(1)
      end

      it "should not add points to a user for a challenge that was already completed" do
        expected_points = user.stats.total_points

        solution.update(status: Solution.statuses[:failed])
        solution.update(status: Solution.statuses[:completed])

        expect(user.stats.total_points).to eq(expected_points)
      end
    end
  end
end
