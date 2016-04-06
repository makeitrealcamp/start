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
#  restricted          :boolean          default(FALSE)
#  preview             :boolean          default(FALSE)
#  pair_programming    :boolean          default(FALSE)
#  difficulty_bonus    :integer
#  timeout             :integer
#
# Indexes
#
#  index_challenges_on_course_id  (course_id)
#

require 'rails_helper'

RSpec.describe Challenge, type: :model do
  context 'associations' do
    it { should belong_to(:course) }
    it { should have_many(:documents) }
  end

  context 'validations ' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :instructions}
  end

  context "friendly_id" do
    it "should update the slug after updating the name" do
      challenge = create(:challenge)
      old_slug = challenge.slug

      # change the name of the challenge
      challenge.name = "#{challenge.name} a random name"
      challenge.save

      expect(challenge.slug).to eq("#{old_slug}-a-random-name")
      expect(challenge.slug).to eq(challenge.friendly_id)
    end
  end
end
