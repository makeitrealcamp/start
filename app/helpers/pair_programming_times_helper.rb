module PairProgrammingTimesHelper

  def days_for_select
    PairProgrammingTime.days.keys.map do |day|
      [ I18n.t("pair_programming_times.days.#{day.to_s}"),day]
    end
  end

  def hours_for_select
    am = ([12] + (1..11).to_a).map{ |h| "%02d AM" % [h] }
    pm = ([12] + (1..11).to_a).map{ |h| "%02d PM" % [h] }
    (am + pm).zip (0..23).to_a
  end

  def minutes_for_select
    (0..59).map { |minute| ['%02d' % [minute],minute] }
  end

  def time_in_time_zone(original_time,time_zone)
    time = original_time.in_time_zone(time_zone)
    day = I18n.t("pair_programming_times.days.#{time.strftime("%A").downcase}")
    time = time.strftime("%I:%M %p GMT%:z")
    "#{day} #{time}"
  end
end
