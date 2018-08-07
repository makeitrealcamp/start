# encoding: UTF-8
class Evaluator::AsyncPhantom < Evaluator::Phantom
  EVALUATOR_PATH = "evaluator_templates/async_phantom/evaluator.js.erb"

  def create_evaluation_file(host, port)
    template = File.read(EVALUATOR_PATH)

    create_util_file
    phantom_util_path = "#{container_path}/phantom_util.js"

    evaluation = @solution.challenge.evaluation

    evaluator_content = ERB.new(template).result(binding)
    evaluator_content += "\n" + evaluation + "\n" + "evaluate(evaluations[0]);"

    create_file(local_path, "evaluation.js", evaluator_content)
  end

end
