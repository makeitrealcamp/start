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

  let!(:user) { create(:user, level: level_1 ) }

  let!(:course) { create(:course) }
  let!(:badge_100) { create(:points_badge, course: course, required_points: 100) }
  let!(:badge_200) { create(:points_badge, course: course, required_points: 200) }
  let!(:badge_300) { create(:points_badge, course: course, required_points: 300) }

  context "when a user earns points" do
    it "changes the user level if it has the next level required points" do
      user.points.create(points: 100, course: course )
      expect(user.reload.level).to eq level_2
    end

    it "changes the user level if it has not reached the next level required points" do
      user.points.create(points: 99, course: course )
      expect(user.reload.level).to eq level_1
    end

    it "assigns the correct level for the user amount of points even if it needs to skip levels" do
      user.points.create(points: 1001, course: course )
      expect(user.reload.level).to eq level_3
    end

    describe "Badges assignment" do
      it "Should assign badges to user according to courses points" do
        user.points.create(points: 100, course: course )
        expect(user.badges.exists? badge_100.id).to eq true
        expect(user.badges.exists? badge_200.id).to eq false
        expect(user.badges.exists? badge_300.id).to eq false
      end

      it "Should not assign multiple times the same badge" do
        user.points.create(points: 100, course: course )
        user.points.create(points: 100, course: course )
        expect(user.badges.where(id: badge_100.id).count).to eq 1
      end

      it "Should assign multiple badges if the user earns sufficient points" do
        user.points.create(points: 1000, course: course )
        expect(user.badges.exists? badge_100.id).to eq true
        expect(user.badges.exists? badge_200.id).to eq true
        expect(user.badges.exists? badge_300.id).to eq true
      end

      it "Should not assign badges if the user doesn't have sufficient points" do
        user.points.create(points: 99, course: course )
        expect(user.badges.exists? badge_100.id).to eq false
        expect(user.badges.exists? badge_200.id).to eq false
      end

      it "Should not assign badges of course A if the user earns points for a course B" do
        user.points.create(points: 1000, course: create(:course) )
        expect(user.badges.exists? badge_100.id).to eq false
        expect(user.badges.exists? badge_200.id).to eq false
      end
    end
  end
  
end
