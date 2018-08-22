class Evaluator::Git < Evaluator::Base
  def initialize(solution)
    @solution = solution
  end

  def prepare
    if !Octokit.repository?(@solution.repository)
      fail("No se encontró el repositorio #{@solution.repository}")
    end
  end

  def execute
    challenge = @solution.challenge

    eval "module Evaluator#{@solution.id}; end"
    eval "Evaluator#{@solution.id}.instance_eval(%q{#{challenge.evaluation}})" # this creates an evaluate method used below

    error = SimpleTimeout::timeout(challenge.timeout) do
      eval "Evaluator#{@solution.id}.evaluate(@solution.repository)"
    end
    error ? fail(error) : complete
  rescue SimpleTimeout::Error
    fail_timeout
  end

  def clean
  end
end
