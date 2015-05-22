class GitPREvaluator < Evaluator
  def evaluate(solution)
    challenge = solution.challenge
    repo = "makeitrealcamp/students"
    
    client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
    pr = client.pull_request(repo, solution.pull_request)

    eval "module Evaluator#{solution.id}; end"
    eval "Evaluator#{solution.id}.instance_eval(%q{#{challenge.evaluation}})" # this creates an evaluate method used below

    error = eval "Evaluator#{solution.id}.evaluate(client, repo, pr)"

    error ? fail(solution, error) : complete(solution)
  rescue Octokit::NotFound => e
    fail(solution, "No se encontró el pull request ##{solution.pull_request} en https://github.com/#{repo}")
  rescue Exception => e
    puts e.message
    puts e.backtrace

    fail(solution, "Hemos encontrado un error en el evaluador, favor reportar a info@makeitreal.camp: #{e.message}")
  end
end