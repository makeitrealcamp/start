# == Schema Information
#
# Table name: resources
#
#  id            :integer          not null, primary key
#  subject_id    :integer
#  title         :string(100)
#  description   :string
#  row           :integer
#  type_old      :integer
#  url           :string
#  time_estimate :string(50)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  content       :text
#  slug          :string
#  published     :boolean
#  video_url     :string
#  category      :integer
#  own           :boolean
#  type          :string(100)
#
# Indexes
#
#  index_resources_on_subject_id  (subject_id)
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
