module ResourcesHelper

  def types_resources
    [["External URL", "url"], ["Markdown Document", "markdown"],["Course","course"]]
  end

  def video_duration(lesson)
    "(#{lesson.video_duration})" if lesson.video_duration?
  end

end
