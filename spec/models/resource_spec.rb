# == Schema Information
#
# Table name: resources
#
#  id            :integer          not null, primary key
#  subject_id    :integer
#  title         :string(100)
#  description   :string
#  row           :integer
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

RSpec.describe Resource, type: :model do

  context 'associations' do
    subject { build(:external_url) }
    it { should belong_to(:subject) }
    it { should have_many(:resource_completions) }
  end

  context "friendly_id" do
    it "should update the slug after updating the name" do
      resource = create(:external_url)
      old_slug = resource.slug
      resource.title = resource.title+" un nombre random"
      resource.save
      expect(resource.slug).to eq("#{old_slug}-un-nombre-random")
      expect(resource.slug).to eq(resource.friendly_id)
    end
  end

  context 'validations' do
    subject { build(:external_url) }
    it { is_expected.to validate_presence_of :title }
    context 'when type is ExternalUrl' do
      it { is_expected.to validate_presence_of :url }
      it { is_expected.not_to allow_value('url.com').for(:url) }
    end

    context 'when type is markdown' do
      subject { build(:markdown) }
      it { should validate_presence_of :content }
    end
  end

  it "has a valid factory" do
    expect(build(:external_url)).to be_valid
  end
end
