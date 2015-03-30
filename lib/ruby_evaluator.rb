class RubyEvaluator
  def evaluate(solution)
    challenge = solution.challenge
    begin
      eval "module Evaluator#{solution.id}; end"
      eval "Evaluator#{solution.id}.instance_eval(%q{#{challenge.evaluation}})" # this creates an evaluate method used below
      files = solution.documents.each_with_object({}) { |document, f| f[document.name] = document }
      error = eval "Evaluator#{solution.id}.evaluate(files)"

      solution.status = error ? :failed : :completed
      solution.error_message = error ? error : nil
      solution.completed_at = DateTime.current if solution.completed?

      solution.save!
    rescue Exception => e
      puts e.message
      puts e.backtrace

      solution.status = "Failed"
      solution.error_message = "Hemos encontrado un error en el evaluador, favor reportar a info@makeitreal.camp: #{e.message}"
      solution.save!
    end
  end
end