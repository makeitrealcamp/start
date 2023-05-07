# == Schema Information
#
# Table name: activity_logs
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  activity_id   :integer
#  activity_type :string
#  name          :string
#  description   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_activity_logs_on_activity_type_and_activity_id  (activity_type,activity_id)
#  index_activity_logs_on_user_id                        (user_id)
#

require 'rails_helper'

RSpec.describe ActivityLog, type: :model do
  context "associations" do
    it { should belong_to(:activity).optional }
    it { should belong_to(:user) }
  end

  context "validations" do
    it { should validate_presence_of :user }
    it { should validate_presence_of :description }
  end

  it "has a valid factory" do
    expect(build(:activity_log)).to be_valid
  end
end
