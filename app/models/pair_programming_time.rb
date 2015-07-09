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
    Time.new(1991,11,1,self.send("#{time}_time_hour"),self.send("#{time}_time_minute"),0,time_zone_offset)
  end

  def formatted_x_time(time)
    "%02d:%02d" % [self.send("#{time}_time_hour"),self.send("#{time}_time_minute")]
  end
end
