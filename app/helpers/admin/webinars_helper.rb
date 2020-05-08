module Admin::WebinarsHelper
  def webinar_hours_options(selected_time)
    from = Time.parse("08:00")
    to = Time.parse("20:30")

    options = []
    (from.to_i .. to.to_i).step(30.minute) do |time|
      option = Time.at(time)
      options.push([option.strftime("%l:%M %P"), option.strftime("%H:%M")])
    end

    options_for_select(options, selected_time.strftime("%H:%M"))
  end
end
