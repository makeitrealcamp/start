# == Schema Information
#
# Table name: challenges
#
#  id                  :integer          not null, primary key
#  course_id           :integer
#  name                :string(100)
#  instructions        :text
#  evaluation          :text
#  row                 :integer
#  published           :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  slug                :string
#  evaluation_strategy :integer
#  solution_video_url  :string
#  solution_text       :text
#  restricted          :boolean          default("false")
#  preview             :boolean          default("true")
#

require 'rails_helper'

RSpec.describe Challenge, type: :model do
  let(:challenge){create(:challenge)}
  subject { Challenge.new }

  context 'associations' do
    it { should belong_to(:course) }
    it { should have_many(:documents) }
  end

  context 'validations ' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :instructions}
  end
end
