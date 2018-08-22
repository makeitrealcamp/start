class Evaluator::GitPR < Evaluator::Base
  def initialize(solution)
    @solution = solution
  end

  def prepare
  end

  def execute
    challenge = @solution.challenge
    repo = "makeitrealcamp/students"

    client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
    pr = client.pull_request(repo, @solution.pull_request)

    eval "module Evaluator#{@solution.id}; end"
    eval "Evaluator#{@solution.id}.instance_eval(%q{#{challenge.evaluation}})" # this creates an evaluate method used below

    error = SimpleTimeout::timeout(@solution.challenge.timeout) do
      eval "Evaluator#{@solution.id}.evaluate(client, repo, pr)"
    end

    error ? fail(error) : complete
  rescue Octokit::NotFound => e
    fail("No se encontró el pull request ##{@solution.pull_request} en https://github.com/#{repo}")
  rescue SimpleTimeout::Error
    fail_timeout
  end

  def clean
  end
end
