class GitPREvaluator < Evaluator
  def evaluate(solution)
    challenge = solution.challenge
    repo = "makeitrealcamp/students"

    client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
    pr = client.pull_request(repo, solution.pull_request)

    eval "module Evaluator#{solution.id}; end"
    eval "Evaluator#{solution.id}.instance_eval(%q{#{challenge.evaluation}})" # this creates an evaluate method used below

    error = SimpleTimeout::timeout(solution.challenge.timeout) do
      eval "Evaluator#{solution.id}.evaluate(client, repo, pr)"
    end

    error ? fail(solution, error) : complete(solution)
  rescue Octokit::NotFound => e
    fail(solution, "No se encontró el pull request ##{solution.pull_request} en https://github.com/#{repo}")
  rescue SimpleTimeout::Error
    fail_timeout(solution)
  rescue Exception => unknown_error
    fail_unknown(solution,unknown_error)
  end
end
