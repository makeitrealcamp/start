# == Schema Information
#
# Table name: users
#
#  id             :integer          not null, primary key
#  email          :string(100)
#  roles          :string           is an Array
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  last_active_at :datetime
#  profile        :hstore
#  status         :integer
#  settings       :hstore
#  account_type   :integer
#  nickname       :string
#  level_id       :integer
#  path_id        :integer
#
# Indexes
#
#  index_users_on_level_id  (level_id)
#

require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user){ create(:user) }
  let!(:course) { create(:course) }
  subject { User.new }

  context 'associations' do
    it { should have_many(:solutions).dependent(:destroy) }
    it { should have_many(:resource_completions) }
    it { should have_many(:auth_providers).dependent(:destroy) }
    it { should have_many(:badge_ownerships).dependent(:destroy) }
    it { should have_many(:badges) }
  end

  context 'validations ' do
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should validate_uniqueness_of :nickname }
    it { should should_not allow_value("email.example").for(:email) }
    it { should should_not allow_value("lorem.ipsum").for(:nickname) }
  end

  context 'default_values' do
    it "should be initialized with default values" do
      user = User.new
      expect(user.roles).to eq(["user"])
      expect(user.status).to eq("created")
      expect(user.has_public_profile).to eq(false)
      expect(user.account_type).to eq("free_account")
    end
  end

  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  describe '#type_student' do
    it 'return true when type is free' do
      expect(user.free_account?).to be true
    end
  end

  describe '#completed_challenges' do
    it 'without challenges completed' do
      create(:challenge, course: course, published: false, restricted: true)
      create(:challenge, course: course, published: true, restricted: true)
      expect(user.stats.completed_challenges_by_course_count(course)).to eq 0
    end

    it 'return only the challenges completed and published'  do

      challenge = create(:challenge, course: course, published: true, restricted: true)
      challenge1 = create(:challenge, course: course, published: false, restricted: true)
      challenge2 = create(:challenge, course: course, published: true, restricted: true)
      #when the challenge is published does count as completed
      create(:solution, user: user, challenge: challenge, status: :completed)
      #when the challenge is not published does not count as completed
      create(:solution, user: user, challenge: challenge1, status: :completed)
      #when the challenge is published and the solution have status different to completed
      #does not count as completed
      create(:solution, user: user, challenge: challenge2, status: :created)
      expect(user.stats.completed_challenges_by_course_count(course)).to eq 1
    end
  end

  describe '#completed_resources' do
    it 'without resources completed' do
      resource  = create(:resource, course: course, published: true)
      resource1 = create(:resource, course: course, published: false)
      resource2 = create(:resource, course: course, published: true)
      expect(user.stats.completed_resources_by_course_count(course)).to eq 0
    end

    it 'return only the resources completed and published' do
      resource  = create(:resource, course: course, published: true)
      resource1 = create(:resource, course: course, published: false)
      resource2 = create(:resource, course: course, published: true)

      create(:resource_completion, user: user, resource: resource)
      create(:resource_completion, user: user, resource: resource1)
      create(:resource_completion, user: user, resource: resource2)
      expect(user.stats.completed_resources_by_course_count(course)).to eq 2
    end
  end

  describe '#progress' do
    it 'return 1.0 when the total is 0' do
      expect(user.stats.progress_by_course(course)).to eq 1.0
    end

    it 'return percentage ' do
      challenge = create(:challenge, course: course, published: true, restricted: true)
      challenge1 = create(:challenge, course: course, published: false, restricted: true)
      create(:solution, user: user, challenge: challenge, status: :completed)

      project  = create(:project, course: course, published: true)
      project1 = create(:project, course: course, published: false)
      project2 = create(:project, course: course, published: true)

      project_solution = create(:project_solution, user: user, project: project)

      expect(user.stats.progress_by_course(course)).to be < 1.0
    end
  end

  describe "#stats" do
    describe "#completed_challenges" do
      it "should return completed and published challenges count" do
        challenge = create(:challenge, course: course, published: true, restricted: true)
        challenge1 = create(:challenge, course: course, published: false, restricted: true)
        challenge2 = create(:challenge, course: course, published: true, restricted: true)
        #when the challenge is published does count as completed
        create(:solution, user: user, challenge: challenge, status: :completed)
        #when the challenge is not published does not count as completed
        create(:solution, user: user, challenge: challenge1, status: :completed)
        #when the challenge is published and the solution have status different to completed
        #does not count as completed
        create(:solution, user: user, challenge: challenge2, status: :created)
        expect(user.stats.completed_challenges_count).to eq 1
      end

      it "should return UNIQ completed challenges count" do
        challenge = create(:challenge, course: course, published: true, restricted: true)
        create(:solution, user: user, challenge: challenge, status: :completed)
        create(:solution, user: user, challenge: challenge, status: :completed)
        create(:solution, user: user, challenge: challenge, status: :completed)

        expect(user.stats.completed_challenges_count).to eq 1
      end
    end

    describe "#total_points" do
      it "Should sum an user total points" do
        user.points.create(course_id: course.id, points: 10)
        user.points.create(course_id: course.id, points: 10)
        expect(user.stats.total_points).to eq 20
      end
    end

    describe "#badges_count" do
      context "When a user has only the 'hago parte de MIR' badge" do
        it "should return 1" do
          expect(user.stats.badges_count).to eq(1)
        end
      end

      it "should return correct badges count" do
        badge = create(:badge)

        user.badge_ownerships.create(badge: badge)
        user.badge_ownerships.create(badge: badge)
        user.badge_ownerships.create(badge: badge)
        user.badge_ownerships.create(badge: badge)
        # (1) badge + (1)'hago parte de MIR'
        expect(user.stats.badges_count).to eq 2
      end
    end
  end

  describe "#nickname" do
    it "should assign a nickname before_create" do
      user = build(:user,nickname: "")
      user.save
      expect(user.reload.nickname).not_to eq(nil)
      expect(user.reload.nickname).not_to eq("")
    end
  end

  describe '#next_level' do
    let!(:level){ create(:level) }
    let!(:level_1){ create(:level_1) }
    let!(:level_2){ create(:level_2) }

    it 'should return a next level' do
      expect(user.next_level).to eq level_1
    end

    context 'when has completed all levels' do
      it 'should return a nil' do
        create(:point, points: 300, user: user)
        expect(user.next_level).to be_nil
      end
    end
  end
end
