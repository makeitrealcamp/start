class EvaluationJob < ActiveJob::Base
  def perform(solution_id)
    solution = Solution.find(solution_id)
    solution.evaluate
  end
end