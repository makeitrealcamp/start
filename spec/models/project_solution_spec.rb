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

  let!(:project_solution){ create(:project_solution) }
  let!(:admin){ create(:admin) }
  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:project)}
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

  context 'validation repository field' do
    context 'when repository does not exist' do
      it 'should not be valid' do
        username = Faker::Internet.user_name
        repository = Faker::Internet.slug('foo bar', '-')
        expect(build(:project_solution, repository: "#{username}/#{repository}")).not_to be_valid
      end
    end

    context 'when the format is not valid' do
      it 'should not be valid' do
        expect(build(:project_solution, repository: "lorem")).not_to be_valid
      end
    end
  end


  context 'default_values' do
    it "should be initialized with default values" do
      expect(project_solution.pending_review?).to be true
    end
  end

  describe "#notify_mentors" do
    it "should send email" do
      expect { project_solution.notify_mentors }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
    it "should call #notifiy_mentors after creation" do
      project_solution = build(:project_solution)
      expect(project_solution).to receive(:notify_mentors)
      project_solution.save
    end

    context "project_solution is reviewed" do
      before do
        project_solution.reviewed!
      end
      it "should call #notifiy_mentors when status changes to pending_review" do
        expect(project_solution).to receive(:notify_mentors)
        project_solution.pending_review!
      end
    end

    context "project_solution is pending_review" do
      before do
        project_solution.pending_review!
      end
      it "should not call #notifiy_mentors when its updated" do
        expect(project_solution).to_not receive(:notify_mentors)
        project_solution.update(summary: Faker::Lorem.sentence)
      end
    end

  end
end
