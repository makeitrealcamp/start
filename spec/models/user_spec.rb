# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(100)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  last_active_at  :datetime
#  profile         :hstore
#  status          :integer
#  settings        :hstore
#  account_type    :integer
#  nickname        :string
#  level_id        :integer
#  password_digest :string
#  access_type     :integer          default("0")
#  current_points  :integer          default("0")
#
# Indexes
#
#  index_users_on_level_id  (level_id)
#

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should define_enum_for :status }
  it { should define_enum_for :account_type }

  context "associations" do
    it { is_expected.to belong_to(:level) }

    it { is_expected.to have_many(:solutions).dependent(:destroy) }
    it { is_expected.to have_many(:challenges) }
    it { is_expected.to have_many(:resource_completions).dependent(:delete_all) }
    it { is_expected.to have_many(:lesson_completions) }
    it { is_expected.to have_many(:project_solutions) }
    it { is_expected.to have_many(:projects) }
    it { is_expected.to have_many(:points) }
    it { is_expected.to have_many(:challenge_completions).dependent(:delete_all) }
    it { is_expected.to have_many(:lesson_completions) }
    it { is_expected.to have_many(:auth_providers).dependent(:destroy) }
    it { is_expected.to have_many(:badge_ownerships).dependent(:destroy) }
    it { is_expected.to have_many(:badges) }
    it { is_expected.to have_many(:notifications) }
    it { is_expected.to have_many(:comments) }
    it { is_expected.to have_many(:quiz_attempts) }
    it { is_expected.to have_many(:path_subscriptions) }
    it { is_expected.to have_many(:paths) }
  end

  context "validations" do
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_uniqueness_of :email }
    it { is_expected.to validate_uniqueness_of :nickname }
    it { is_expected.not_to allow_value("email.example").for(:email) }
    it { is_expected.not_to allow_value("lorem.ipsum").for(:nickname) }
    it { should allow_value("hello-nice_world").for(:nickname) }
  end

  context 'default_values' do
    it "should be initialized with default values" do
      user = User.new
      expect(user.status).to eq("created")
      expect(user.has_public_profile).to eq(false)
      expect(user.account_type).to eq("free_account")
    end
  end

  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  describe ".completed_challenges_by_subject_count" do
    let!(:user) { create(:user) }
    let!(:subject) { create(:subject) }

    context "when user has no completed challenges" do
      it "returns 0" do
        create(:challenge, subject: subject, published: false, restricted: true)
        create(:challenge, subject: subject, published: true, restricted: true)

        expect(user.stats.completed_challenges_by_subject_count(subject)).to eq 0
      end
    end

    it "includes only completed solutions of published challenges" do
      # published challenge with completed solution
      challenge = create(:challenge, subject: subject, published: true, restricted: true)
      create(:solution, user: user, challenge: challenge, status: :completed)

      # unpublished challenge with completed solution
      challenge1 = create(:challenge, subject: subject, published: false, restricted: true)
      create(:solution, user: user, challenge: challenge1, status: :completed)

      # published challenge but not completed solution
      challenge2 = create(:challenge, subject: subject, published: true, restricted: true)
      create(:solution, user: user, challenge: challenge2, status: :created)

      expect(user.stats.completed_challenges_by_subject_count(subject)).to eq 1
    end
  end

  describe ".completed_resources_by_subject_count" do
    let!(:user) { create(:user) }
    let!(:subject) { create(:subject) }

    context "when user has no completed resources" do
      it "returns 0" do
        create(:resource, subject: subject, published: true)
        create(:resource, subject: subject, published: false)
        create(:resource, subject: subject, published: true)

        expect(user.stats.completed_resources_by_subject_count(subject)).to eq 0
      end
    end

    it "includes only completed published resources" do
      # completed publised resource
      resource  = create(:resource, subject: subject, published: true)
      create(:resource_completion, user: user, resource: resource)

      # completed unpublished resource
      resource1 = create(:resource, subject: subject, published: false)
      create(:resource_completion, user: user, resource: resource1)

      # completed published resource
      resource2 = create(:resource, subject: subject, published: true)
      create(:resource_completion, user: user, resource: resource2)

      expect(user.stats.completed_resources_by_subject_count(subject)).to eq 2
    end
  end

  describe ".progress_by_subject" do
    let!(:user) { create(:user) }
    let!(:subject) { create(:subject) }

    it 'returns 1.0 when the total is 0' do
      expect(user.stats.progress_by_subject(subject)).to eq 1.0
    end

    it "returns percentage" do
      challenge = create(:challenge, subject: subject, published: true, restricted: true)
      challenge1 = create(:challenge, subject: subject, published: false, restricted: true)
      create(:solution, user: user, challenge: challenge, status: :completed)

      project  = create(:project, subject: subject, published: true)
      project1 = create(:project, subject: subject, published: false)
      project2 = create(:project, subject: subject, published: true)

      project_solution = create(:project_solution, user: user, project: project)

      expect(user.stats.progress_by_subject(subject)).to be < 1.0
    end
  end

  describe ".completed_challenges_count" do
    let(:user) { create(:user) }
    let(:subject) { create(:subject) }

    it "returns completed and published challenges count" do
      challenge = create(:challenge, subject: subject, published: true, restricted: true)
      challenge1 = create(:challenge, subject: subject, published: false, restricted: true)
      challenge2 = create(:challenge, subject: subject, published: true, restricted: true)
      #when the challenge is published does count as completed
      create(:solution, user: user, challenge: challenge, status: :completed)
      #when the challenge is not published does not count as completed
      create(:solution, user: user, challenge: challenge1, status: :completed)
      #when the challenge is published and the solution have status different to completed
      #does not count as completed
      create(:solution, user: user, challenge: challenge2, status: :created)
      expect(user.stats.completed_challenges_count).to eq 1
    end

    it "returns UNIQ completed challenges count" do
      challenge = create(:challenge, subject: subject, published: true, restricted: true)
      create(:solution, user: user, challenge: challenge, status: :completed)
      create(:solution, user: user, challenge: challenge, status: :completed)
      create(:solution, user: user, challenge: challenge, status: :completed)

      expect(user.stats.completed_challenges_count).to eq 1
    end
  end

  describe ".total_points" do
    let!(:user) { create(:user) }
    let!(:subject) { create(:subject) }

    it "sums user's total points" do
      user.points.create!(subject_id: subject.id, points: 10, pointable: create(:solution))
      user.points.create!(subject_id: subject.id, points: 10, pointable: create(:solution))
      expect(user.stats.total_points).to eq 20
    end
  end

  describe ".badges_count" do
    let!(:user) { create(:user) }

    context "when a user has only the 'hago parte de MIR' badge" do
      it "returns 1" do
        expect(user.stats.badges_count).to eq(1)
      end
    end

    it "returns correct badges count" do
      badge = create(:badge)

      user.badge_ownerships.create(badge: badge)
      user.badge_ownerships.create(badge: badge)
      user.badge_ownerships.create(badge: badge)
      user.badge_ownerships.create(badge: badge)
      # (1) badge + (1)'hago parte de MIR'
      expect(user.stats.badges_count).to eq 2
    end
  end

  describe ".nickname" do
    it "assigns a nickname before_create" do
      user = build(:user, nickname: "")
      user.save
      expect(user.reload.nickname).not_to eq(nil)
      expect(user.reload.nickname).not_to eq("")
    end
  end

  describe ".next_level" do
    let!(:user) { create(:user) }
    let!(:level) { create(:level) }
    let!(:level_1) { create(:level, required_points: 100) }
    let!(:level_2) { create(:level, required_points: 200) }

    it "returns the next level" do
      expect(user.next_level).to eq level_1
    end

    context "when has completed all levels" do
      it "returns nil" do
        create(:point, points: 300, user: user)
        expect(user.next_level).to be_nil
      end
    end
  end

  describe ".next_challenge" do
    context "when there are no solution" do
      it "returns the first challenge" do
        user = create(:user_with_path)

        subject1 = create(:subject_with_phase, row: 0)
        challenge1 = create(:challenge, subject: subject1)

        subject2 = create(:subject_with_phase, row: 10)
        challenge3 = create(:challenge, subject: subject2)

        expect(user.next_challenge).to eq(challenge1)
      end
    end

    context "when last solution is not completed" do
      it "returns the challenge of last solution" do
        user = create(:user_with_path)

        subject1 = create(:subject_with_phase, row: 0)
        challenge1 = create(:challenge, subject: subject1)
        challenge2 = create(:challenge, subject: subject1)

        create(:solution, user: user, challenge: challenge2, status: :created)

        expect(user.next_challenge).to eq(challenge2)
      end
    end

    context "when last solution is completed" do
      it "returns the next challenge that hasn't been attempted" do
        user = create(:user_with_path)

        subject1 = create(:subject_with_phase, row: 0)
        challenge1 = create(:challenge, subject: subject1) # this is going to be the last solved
        challenge2 = create(:challenge, subject: subject1) # this is going to be solved

        subject2 = create(:subject_with_phase, row: 10)
        challenge3 = create(:challenge, subject: subject2) # this should be the next challenge

        create(:solution, user: user, challenge: challenge1, status: :completed, updated_at: DateTime.current)
        create(:solution, user: user, challenge: challenge2, status: :completed, updated_at: 1.month.ago)

        expect(user.next_challenge).to eq(challenge3)
      end
    end
  end

  describe ".log_activity" do
    context "when the user activates" do
      it "logs the activity" do
        user = create(:user, status: :created)
        expect { user.activate! }.to change(ActivityLog, :count).by(1)
      end
    end

    context "when the user is suspended" do
      it "logs the activity" do
        user = create(:user)
        expect { user.suspended! }.to change(ActivityLog, :count).by(1)
      end
    end

    context "when the user finishes" do
      it "logs the activity" do
        user = create(:user)
        expect { user.finished! }.to change(ActivityLog, :count).by(1)
      end
    end

    context "when the user is reactivated" do
      it "logs the activity" do
        user = create(:user, status: :suspended)
        expect { user.active! }.to change(ActivityLog, :count).by(1)
      end
    end
  end
end
