module ChallengesHelper
  def codemirror_mode(name)
    mode = {"html" => "htmlmixed", "js" => "javascript", "rb" => "ruby", "css" => "css", "sql" => "sql"}
    mode[name.split(".")[1]]
  end
end
