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

  def fail_unknown(solution, error)
    message = "Hemos encontrado un error en el evaluador, favor reportar a tu mentor:\n\n"
    message += "#{error.message}: \n"
    message += "\t#{error.backtrace.join("\n\t")}"
    message = message.gsub("/ukku/data/", "")
    fail(solution, message.truncate(650))
  end

end
