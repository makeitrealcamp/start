# == Schema Information
#
# Table name: lesson_completions
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  lesson_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_lesson_completions_on_lesson_id  (lesson_id)
#  index_lesson_completions_on_user_id    (user_id)
#

require 'rails_helper'

RSpec.describe LessonCompletion, type: :model do
  context "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:lesson) }
  end

  context "validations" do
    it { should validate_presence_of :user }
    it { should validate_presence_of :lesson }
  end

  it "has a valid factory" do
    expect(build(:lesson_completion)).to be_valid
  end
end
