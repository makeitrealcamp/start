module ChallengesHelper
  def codemirror_modes
    {"html" => "htmlmixed", "js" => "javascript", "rb" => "ruby", "css" => "css", "sql" => "sql"}
  end

  def codemirror_mode(name)
    codemirror_modes[name.split(".")[1]]
  end

  def evaluation_strategies
    [
      ["Ruby (Embedded Files)", "ruby_embedded"],
      ["PhantomJS (Embedded Files)", "phantomjs_embedded"],
      ["Async PhantomJS (Embedded Files)", "async_phantomjs_embedded"],
      ["Ruby (Git)", "ruby_git"],
      ["Rails (Git)", "rails_git"],
      ["Sinatra (Git)", "sinatra_git"],
      ["Ruby (Git PR)", "ruby_git_pr"],
      ["React (Git)", "react_git"],
      ["NodeJS (Embedded)", "nodejs_embedded"]
    ]
  end
end
