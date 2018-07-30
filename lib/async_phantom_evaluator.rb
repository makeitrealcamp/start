# encoding: UTF-8
class AsyncPhantomEvaluator < PhantomEvaluator
  ASYNC_PHANTOM_EVALUATOR_TEMPLATE_PATH = "evaluator_templates/async_phantom_evaluator_template.js.erb"

  def create_evaluation_file(host, port)
    template = File.read(ASYNC_PHANTOM_EVALUATOR_TEMPLATE_PATH)
    # required for template: host,port,phantom_util_path
    phantom_util_path = create_phantom_util_file[:container_path]

    evaluation = self.solution.challenge.evaluation

    evaluator_content = ERB.new(template).result(binding)
    evaluator_content += "\n" + evaluation + "\n" + "evaluate(evaluations[0]);"

    create_shared_file("evaluation.js",evaluator_content)
  end

end
