# == Schema Information
#
# Table name: points
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  subject_id     :integer
#  points         :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  pointable_id   :integer
#  pointable_type :string
#
# Indexes
#
#  index_points_on_pointable_type_and_pointable_id  (pointable_type,pointable_id)
#  index_points_on_subject_id                       (subject_id)
#

class Point < ApplicationRecord
  belongs_to :subject
  belongs_to :user
  belongs_to :pointable, polymorphic: true

  validates :user, presence: true

  after_create :handle_after_create

  def self.accumulated_by_day(range)
    by_day = Point.where(created_at: range).group("date_trunc('day', created_at)").sum(:points)
    by_day = Hash[by_day.map { |key, value| [key.to_date, value] }] # convert Time to Date

    points = 0
    (range.min.to_date..range.max.to_date).map do |date|
      points += by_day.fetch(date, 0)
      { date: date, points: points }
    end
  end

  private
    def handle_after_create
      add_points_to_user
      check_user_level!
      check_user_badges!
      notify_user
    end

    def add_points_to_user
      self.user.update(current_points: self.user.points.sum(:points))
    end

    def check_user_level!
      new_level = Level.for_points(self.user.current_points)
      unless new_level.nil?
        user.level = new_level
        user.save!
      end
    end

    def check_user_badges!
      new_badges = Badge.granted_by_points
        .where.not(id: self.user.badges)
        .where(subject_id: self.subject)
        .where("required_points <= ?",self.user.stats.points_per_subject(self.subject))
      user.badges << new_badges
    end

    def notify_user
      user.notifications.create!(notification_type: :points_earned, data: { point_id: self.reload.id })
    end
end
