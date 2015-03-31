class GitEvaluator
  def evaluate(solution)
    challenge = solution.challenge
    
    if !Octokit.repository?(solution.url)
      solution.status = :failed
      solution.error_message = "No se encontró el repositorio #{solution.url}"
      solution.save!
      return
    end

    eval "module Evaluator#{solution.id}; end"
    eval "Evaluator#{solution.id}.instance_eval(%q{#{challenge.evaluation}})" # this creates an evaluate method used below

    error = eval "Evaluator#{solution.id}.evaluate(solution.url)"

    solution.status = error ? :failed : :completed
    solution.error_message = error ? error : nil
    solution.completed_at = DateTime.current if solution.completed?
    solution.save!
  rescue Exception => e
    puts e.message
    puts e.backtrace

    solution.status = :failed
    solution.error_message = "Hemos encontrado un error en el evaluador, favor reportar a info@makeitreal.camp: #{e.message}"
    solution.save!
  end
end