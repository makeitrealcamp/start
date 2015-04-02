class Evaluator
  def fail(solution, message)
    solution.status = :failed
    solution.error_message = message
    solution.save!
  end

  def complete(solution)
    solution.status = :completed
    solution.completed_at = DateTime.current
    solution.error_message = nil
    solution.save!
  end
end