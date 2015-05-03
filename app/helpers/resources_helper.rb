module ResourcesHelper

  def genderize(male, female)
    current_user.gender == "female" ? female : male
  end

  def types_resources
    [["External URL", "url"], ["Markdown Document", "markdown"],["Course","course"]]
  end
end
