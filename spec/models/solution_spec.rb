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

  let(:user) { create(:user) }
  let(:challenge) { create(:challenge) }
  let(:solution) { create(:solution, challenge: challenge, user: user) }

  before do
    create(:level)
    create(:level, required_points: 100)
    create(:level, required_points: 200)
  end

  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:challenge) }
    it { should have_many(:documents) }
  end

  describe "challenge completion" do
    context "when user completes a challenge and creates the correct amount of points" do
      before do
        solution.update(status: Solution.statuses[:completed])
      end
      it "creates a challenge_completion after a challenge is completed for the first time" do
        expect(ChallengeCompletion.find_by_challenge_id(challenge.id)).to_not eq(nil)
      end

      it "creates a challenge_completion after a challenge is completed for the second time" do
        solution.update(status: Solution.statuses[:failed])
        solution.update(status: Solution.statuses[:completed])
        expect(ChallengeCompletion.where(challenge_id: challenge.id).count).to eq(1)
      end

      it "doesn't add points to a user for a challenge that was already completed" do
        expected_points = user.stats.total_points

        solution.update(status: Solution.statuses[:failed])
        solution.update(status: Solution.statuses[:completed])

        expect(user.stats.total_points).to eq(expected_points)
      end
    end
  end

  describe ".as_json" do
    it "returns hash" do
      solution_json = solution.serializable_hash(
        methods: [:error_message, :completed_at],
        include: [:documents]
      )

      expect(solution.as_json({})).to eq solution_json
      expect(solution.as_json({}).class).to eq Hash
    end

    it 'returns hash with user_hash' do
      solution_json = solution.serializable_hash(
        methods: [:error_message, :completed_at, :user_hash],
        include: [:documents]
      )
      expect(solution.as_json({include_user_level: true})).to eq solution_json
      expect(solution.as_json({include_user_level: true}).class).to eq Hash
    end
  end

  describe ".log_activity" do
    context "when created" do
      it "logs the activity" do
        expect { solution }.to change(ActivityLog, :count).by(1)

        activity_log = ActivityLog.last
        expect(activity_log.description).to start_with "Inició"
      end
    end

    context "when a user makes an attempt" do
      it "logs the activity" do
        solution # we need to trigger the let
        expect { solution.failed! }.to change(ActivityLog, :count).by(1)

        activity_log = ActivityLog.last
        expect(activity_log.description).to start_with "Intentó"
      end
    end

    context "when a user completes the solution the first time" do
      it "logs the activity" do
        solution # we need to trigger the let
        expect { solution.completed! }.to change(ActivityLog, :count).by(1)

        activity_log = ActivityLog.last
        expect(activity_log.description).to start_with "Completó"
      end
    end

    context "when a user completes a completed solution" do
      it "doesn't logs the activity" do
        solution.completed!
        expect { solution.completed! }.to_not change(ActivityLog, :count)
      end
    end

    context "when a user attempts a completed solution" do
      it "doesn't logs the activity" do
        solution.completed!
        expect { solution.failed! }.to_not change(ActivityLog, :count)
      end
    end
  end
end
