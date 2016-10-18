# == Schema Information
#
# Table name: quizzes
#
#  id         :integer          not null, primary key
#  name       :string
#  row        :integer
#  slug       :string
#  subject_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  published  :boolean
#
# Indexes
#
#  index_quizzes_on_subject_id  (subject_id)
#

require 'rails_helper'

RSpec.describe Quizer::Quiz, type: :model do

  context 'associations' do
    it { should belong_to(:subject) }
    it { should have_many(:questions) }
    it { should have_many(:quiz_attempts) }
  end

  context 'validations' do
    it { validate_presence_of(:name) }
    it { validate_presence_of(:course) }
  end

  it "should have a valid factory" do
    expect(build(:quiz)).to be_valid
  end
end
