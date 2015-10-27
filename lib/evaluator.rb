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

  def fail_timeout(solution)
    fail(solution, "Se ha exedido el tiempo máximo de ejecución de esta solución. Verifica que no haya ciclos infinitos en tu código.")
  end

  def fail_unknown(solution,error)
    fail(solution, "Hemos encontrado un error en el evaluador, favor reportar a info@makeitreal.camp: #{error.message}".truncate(250))
  end

end
