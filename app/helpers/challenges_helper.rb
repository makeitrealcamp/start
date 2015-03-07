module ChallengesHelper
  def codemirror_modes
    {"html" => "htmlmixed", "js" => "javascript", "rb" => "ruby", "css" => "css", "sql" => "sql"}
  end

  def codemirror_mode(name)
    codemirror_modes[name.split(".")[1]]
  end
end
