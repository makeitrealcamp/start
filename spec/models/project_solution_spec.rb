# == Schema Information
#
# Table name: project_solutions
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  project_id :integer
#  repository :string
#  url        :string
#  summary    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status     :integer
#
# Indexes
#
#  index_project_solutions_on_project_id  (project_id)
#  index_project_solutions_on_user_id     (user_id)
#

require 'rails_helper'

RSpec.describe ProjectSolution, type: :model do
  it { should define_enum_for :status }

  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:project) }
    it { should have_many(:comments) }
  end

  context 'validations' do
    it { should validate_presence_of :project }
    it { should validate_presence_of :user }
    it { should validate_presence_of :repository }
    it { should validate_presence_of :summary }
    it { should_not allow_value("lorem").for(:url) }
  end

  it "has a valid factory" do
    expect(build(:project_solution)).to be_valid
  end

  context "repository validation" do
    context "when repository does not exist" do
      it "is not valid" do
        username = Faker::Internet.user_name
        repository = Faker::Internet.slug("foo bar", "-")
        expect(build(:project_solution, repository: "#{username}/#{repository}")).not_to be_valid
      end
    end

    context 'when the format is not valid' do
      it 'is not valid' do
        expect(build(:project_solution, repository: "lorem")).not_to be_valid
      end
    end
  end

  context 'default_values' do
    it "is initialized with default values" do
      project_solution = ProjectSolution.new
      expect(project_solution.pending_review?).to be true
    end
  end

  describe "#after_save" do
    let(:project_solution) { build(:project_solution) }

    it "calls .notify_mentors" do
      expect(project_solution).to receive(:notify_mentors_if_pending_review)
      project_solution.save!
    end

    context "when project solution is reviewed" do
      it "calls .notify_mentors when status changes to pending_review" do
        expect(project_solution).to receive(:notify_mentors)
        project_solution.pending_review!
      end
    end

    context "when project solution is pending review" do
      before { project_solution.pending_review! }

      it "doesn't call .notifiy_mentors when it's updated" do
        expect(project_solution).to_not receive(:notify_mentors)
        project_solution.update(summary: Faker::Lorem.sentence)
      end
    end
  end

  describe ".log_activity" do
    context "when the solution is created" do
      it "logs the activity" do
        expect { create(:project_solution) }.to change(ActivityLog, :count).by(1)
      end
    end
  end
end
