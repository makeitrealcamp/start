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
  end

  it "has a valid factory" do
    expect(build(:project_solution)).to be_valid
  end

  context 'default_values' do
    it "should be initialized with default values" do
      expect(project_solution.pending_review?).to be true
    end
  end

  describe '#notify_mentors' do
    it 'send email' do
      expect { project_solution.notify_mentors }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
