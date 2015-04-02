class GitEvaluator < Evaluator
  def evaluate(solution)
    challenge = solution.challenge
    
    if !Octokit.repository?(solution.repository)
      fail(solution, "No se encontró el repositorio #{solution.repository}")
      return
    end

    eval "module Evaluator#{solution.id}; end"
    eval "Evaluator#{solution.id}.instance_eval(%q{#{challenge.evaluation}})" # this creates an evaluate method used below

    error = eval "Evaluator#{solution.id}.evaluate(solution.repository)"

    error ? fail(solution, solution.error) : complete(solution)
  rescue Exception => e
    puts e.message
    puts e.backtrace

    fail(solution, "Hemos encontrado un error en el evaluador, favor reportar a info@makeitreal.camp: #{e.message}")
  end
end