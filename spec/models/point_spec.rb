# == Schema Information
#
# Table name: points
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  course_id      :integer
#  points         :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  pointable_id   :integer
#  pointable_type :string
#
# Indexes
#
#  index_points_on_course_id                        (course_id)
#  index_points_on_pointable_type_and_pointable_id  (pointable_type,pointable_id)
#

require 'rails_helper'

RSpec.describe Point, type: :model do

  let!(:level_1) { create(:level) }
  let!(:level_2) { create(:level, name: "teclado amarrilo", required_points: 100) }
  let!(:level_3) { create(:level, name: "teclado negro", required_points: 1000) }
  let!(:user) { create(:paid_user, level: level_1 ) }
  let!(:user) { create(:paid_user, level: level_1 ) }
  let!(:course) { create(:course) }


  describe "events that occur after creation of points" do
    context "user is in level 1" do
      it "Should change the user level if it has the next level requiered points" do
        user.points.create(points: 100, course: course )
        expect(user.reload.level).to eq level_2
      end

      it "Should not change the user level if it has not reached the next level requiered points" do
        user.points.create(points: 99, course: course )
        expect(user.reload.level).to eq level_1
      end

      it "Should assign the correct level for the user amount of points even if it needs to skip levels" do
        user.points.create(points: 1001, course: course )
        expect(user.reload.level).to eq level_3
      end
    end
  end
end
