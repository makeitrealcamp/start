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
#  free_preview   :boolean          default(FALSE)
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

  describe "#next" do

    let!(:admin) { create(:admin) }
    let!(:free_user) { create(:free_user) }

    let!(:course_1) { create(:published_video_course) }
      let!(:section_1_1) { create(:section,resource: course_1,row_position: 0) }
        let!(:lesson_1_1_1) { create(:free_lesson,section: section_1_1, row_position: 10,name: "lesson_1_1_1", free_preview: true) }
        let!(:lesson_1_1_2) { create(:paid_lesson,section: section_1_1, row_position: 100,name: "lesson_1_1_2") }
      let!(:section_1_2) { create(:section,resource: course_1, row_position: 100) }
          let!(:lesson_1_2_1) { create(:free_lesson,section: section_1_2, row_position: 0,name: "lesson_1_2_1") }

    let!(:course_2) { create(:published_video_course) }
      let!(:section_2_1) { create(:section,resource: course_2, row_position: 0) }
        let!(:lesson_2_1_1) { create(:paid_lesson,section: section_2_1, row_position: 0,name: "lesson_2_1_1") }
        let!(:lesson_2_1_2) { create(:paid_lesson,section: section_2_1, row_position: 10,name: "lesson_2_1_2") }
        let!(:lesson_2_1_3) { create(:paid_lesson,section: section_2_1, row_position: 100,name: "lesson_2_1_3") }
      let!(:section_2_2) { create(:section,resource: course_2, row_position: 1) }
        let!(:lesson_2_2_1) { create(:free_lesson,section: section_2_2, row_position: 0,name: "lesson_2_2_1") }
        let!(:lesson_2_2_2) { create(:paid_lesson,section: section_2_2, row_position: 10,name: "lesson_2_2_2") }
        let!(:lesson_2_2_3) { create(:paid_lesson,section: section_2_2, row_position: 100,name: "lesson_2_2_3") }
      let!(:section_2_3) { create(:section,resource: course_2, row_position: 2) }
      let!(:section_2_4) { create(:section,resource: course_2, row_position: 3) }
      let!(:section_2_5) { create(:section,resource: course_2, row_position: 4) }
      let!(:section_2_6) { create(:section,resource: course_2, row_position: 100) }
        let!(:lesson_2_6_1) { create(:paid_lesson,section: section_2_6, row_position: 0,name: "lesson_2_6_1") }
        let!(:lesson_2_6_2) { create(:free_lesson,section: section_2_6, row_position: 10,name: "lesson_2_6_2") }
        let!(:lesson_2_6_3) { create(:paid_lesson,section: section_2_6, row_position: 100,name: "lesson_2_6_3") }


    context "when there's a next lesson in the section" do
      it "should return the next lesson of the section" do
        expect(lesson_1_1_1.next(admin)).to eq(lesson_1_1_2)
      end
    end

    context "when there's no more lessons in the section" do
      it "should return the next lesson of the section" do
        expect(lesson_1_1_2.next(admin)).to eq(lesson_1_2_1)
      end
    end

    context "when it's the last lesson" do
      it "should return nil" do
        expect(lesson_1_2_1.next(admin)).to eq(nil)
        expect(lesson_2_6_3.next(admin)).to eq(nil)
      end
    end

    context "when there are empty sections" do
      it "should return next lesson of the next not empty section" do
        expect(lesson_2_2_3.next(admin)).to eq(lesson_2_6_1)
      end
    end

    context "free user" do
      it "should return next lesson free lesson" do
        expect(lesson_1_1_1.next(free_user)).to eq(lesson_1_2_1)
        expect(lesson_2_2_1.next(free_user)).to eq(lesson_2_6_2)
      end

      it "should return nil when there's no more free lessons" do
        expect(lesson_1_2_1.next(free_user)).to eq(nil)
        expect(lesson_2_6_2.next(free_user)).to eq(nil)
      end

    end

  end
end
