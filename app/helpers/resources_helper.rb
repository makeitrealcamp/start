module ResourcesHelper

  def types_resources
    [["External URL", "url"], ["Markdown Document", "markdown"],["Course","course"]]
  end

  def resource_categories
    Resource.categories.keys.map do |category|
      [ I18n.t("resources.categories.#{category.to_s}"),category]
    end
  end

  def video_duration(lesson)
    "#{lesson.video_duration}" if lesson.video_duration?
  end

end
