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

  def durations_for_select
    (30..720).step(30).map do |duration_in_minutes|
      hours = duration_in_minutes/60
      minutes = duration_in_minutes%60
      text = ""
      text += "#{hours} #{'hora'.pluralize(hours)} " if hours > 0
      text += "#{minutes} #{'minuto'.pluralize(minutes)}" if minutes > 0
      [text,duration_in_minutes]
    end
  end
end
