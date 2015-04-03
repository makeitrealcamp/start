class EvaluationJob < ActiveJob::Base
  def perform(solution_id)
    solution = Solution.find(solution_id)
    KMTS.record(solution.user.email, 'Attempted Challenge', { id: solution.challenge.id, name: solution.challenge.name })
    solution.evaluate
  end
end