# == Schema Information
#
# Table name: projects
#
#  id                    :integer          not null, primary key
#  course_id             :integer
#  name                  :string
#  explanation_text      :text
#  explanation_video_url :string
#  published             :boolean
#  row                   :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  difficulty_bonus      :integer          default(0)
#
# Indexes
#
#  index_projects_on_course_id  (course_id)
#

require 'rails_helper'

RSpec.describe Project, type: :model do
  context 'associations' do
    it { should belong_to(:course) }
    it { should have_many(:project_solutions) }
    it { should have_many(:points) }
  end

  context 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :explanation_text }
    it { should validate_presence_of :course }
  end

  it "has a valid factory" do
    expect(build(:project)).to be_valid
  end
end
