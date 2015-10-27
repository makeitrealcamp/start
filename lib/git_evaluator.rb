class GitEvaluator < Evaluator
  def evaluate(solution)
    challenge = solution.challenge

    if !Octokit.repository?(solution.repository)
      fail(solution, "No se encontró el repositorio #{solution.repository}")
      return
    end

    eval "module Evaluator#{solution.id}; end"
    eval "Evaluator#{solution.id}.instance_eval(%q{#{challenge.evaluation}})" # this creates an evaluate method used below

    error = SimpleTimeout::timeout(solution.challenge.timeout) do
      eval "Evaluator#{solution.id}.evaluate(solution.repository)"
    end
    error ? fail(solution, error) : complete(solution)
  rescue SimpleTimeout::Error
    fail_timeout(solution)
  rescue Exception => unknown_error
    fail_unknown(solution,unknown_error)
  end
end
