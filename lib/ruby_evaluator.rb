class RubyEvaluator
  def evaluate(solution)
    challenge = solution.challenge
    begin
      eval %Q(
        module Evaluator#{solution.id}
          def self.format_exception(message)
            message.gsub(/for #<Context:.*>/i, '').gsub(/\\(eval\\)\\:/i, '')
          end
        end
      )
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

      solution.status = :failed
      solution.error_message = "Hemos encontrado un error en el evaluador, favor reportar a info@makeitreal.camp: #{e.message}"
      solution.save!
    end
  end
end