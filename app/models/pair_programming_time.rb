# == Schema Information
#
# Table name: pair_programming_times
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  day               :integer
#  start_time_hour   :integer
#  start_time_minute :integer
#  end_time_hour     :integer
#  end_time_minute   :integer
#  time_zone         :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_pair_programming_times_on_user_id  (user_id)
#

class PairProgrammingTime < ActiveRecord::Base
  belongs_to :user

  enum day: [:monday,:tuesday,:wednesday,:thursday,:friday,:saturday,:sunday]

  validates :user_id, presence: true
  validates :day, presence: true
  validates :start_time_hour, presence: true, inclusion: { in: 0..23 }
  validates :start_time_minute, presence: true, inclusion: { in: 0..59 }
  validates :end_time_hour, presence: true, inclusion: { in: 0..23 }
  validates :end_time_minute, presence: true, inclusion: { in: 0..59  }
  validates :time_zone, presence: true, inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) }

  validate :start_time_before_end_time

  def self.match_times_for(user)
    overlaped_times_ids = []
    where.not(user_id: user.id).find_each do |other|
      overlaps = user.pair_programming_times.any? do |time|
        wrap = other.start_time.between?(time.start_time,time.end_time)
        inside = time.start_time.between?(other.start_time,other.end_time)
        wrap || inside
      end
      overlaped_times_ids << other.id if overlaps
    end
    self.where(id: overlaped_times_ids)
  end

  def start_time
    x_time("start")
  end

  def end_time
    x_time("end")
  end

  def formatted_start_time
    formatted_x_time("start")
  end

  def formatted_end_time
    formatted_x_time("end")
  end

  def time_zone_offset
    active_time_zone = ActiveSupport::TimeZone[self.time_zone]
    return active_time_zone.formatted_offset if active_time_zone
    nil
  end

  protected
  def start_time_before_end_time
    if(self.start_time && self.end_time && (self.start_time >= self.end_time))
      errors.add(:end_time,"debe ser después de Start time")
    end
  end

  def x_time(time)
    # year, month, day and seconds are dummy data
    # 1991-11-4 was a monday
    day_offset = PairProgrammingTime.days[self.day]
    hour = self.send("#{time}_time_hour")
    minute = self.send("#{time}_time_minute")
    Time.new(1991,11,4+day_offset,hour,minute,0,time_zone_offset)
  end

  def formatted_x_time(time)
    "%02d:%02d" % [self.send("#{time}_time_hour"),self.send("#{time}_time_minute")]
  end
end
