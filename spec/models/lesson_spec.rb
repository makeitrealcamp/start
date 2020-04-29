# == Schema Information
#
# Table name: lessons
#
#  id             :integer          not null, primary key
#  section_id     :integer
#  name           :string
#  video_url      :string
#  description    :text
#  row            :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  free_preview   :boolean          default("false")
#  info           :text
#  video_duration :string
#
# Indexes
#
#  index_lessons_on_section_id  (section_id)
#

require 'rails_helper'

RSpec.describe Lesson, type: :model do
  context 'associations' do
    it { should belong_to(:section) }
    it { should have_many(:comments) }
  end

  context 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :video_url }
    it { should_not allow_value("pepe perez").for(:video_url) }
  end

  it "has a valid factory" do
    expect(build(:lesson)).to be_valid
  end

  describe ".next" do
    let(:user) { create(:user) }
    let(:course) { create(:video_course, :published) }
    let(:first_section) { create(:section, resource: course, row_position: 0) }
    let(:first_lesson) { create(:lesson, section: first_section, row_position: 0) }

    context "when there's a next lesson in the section" do
      let!(:second_lesson) { create(:lesson, section: first_section, row_position: 10) }

      it "returns the next lesson of the section" do
        expect(first_lesson.next(user)).to eq(second_lesson)
      end
    end

    context "when there are no more lessons in the section" do
      let!(:second_section) { create(:section, resource: course, row_position: 10) }
      let!(:second_lesson) { create(:lesson, section: second_section, row_position: 0) }

      it "returns the first lesson of the next section" do
        expect(first_lesson.next(user)).to eq(second_lesson)
      end
    end

    context "when it's the last lesson" do
      it "returns nil" do
        expect(first_lesson.next(user)).to be_nil
      end
    end

    context "when there are empty sections before a non empty section" do
      let!(:second_section) { create(:section, resource: course, row_position: 10) } # empty section
      let!(:third_section) { create(:section, resource: course, row_position: 20) }
      let!(:second_lesson) { create(:lesson, section: third_section, row_position: 0) }

      it "returns first lesson of the next non empty section" do
        expect(first_lesson.next(user)).to eq(second_lesson)
      end
    end
  end
end
