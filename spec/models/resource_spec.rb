# == Schema Information
#
# Table name: resources
#
#  id            :integer          not null, primary key
#  course_id     :integer
#  title         :string(100)
#  description   :string
#  row           :integer
#  type          :integer
#  url           :string
#  time_estimate :string(50)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Resource, type: :model do

  let(:course){create(:course)}
  let(:resource){create(:resource, course: course)}
  subject { Resource.new }

  context 'associations' do
    it { should belong_to(:course) }
    it { should  have_and_belong_to_many(:users)}
  end

  context 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :url }
    it { should should_not allow_value('url.com').for(:url)}
  end

  it "has a valid factory" do
    expect(build(:resource)).to be_valid
  end
end
