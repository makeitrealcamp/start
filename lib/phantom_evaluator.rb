# encoding: UTF-8
class PhantomEvaluator < BaseDockerEvaluator

  PHANTOM_EVALUATOR_TEMPLATE_PATH = "evaluator_templates/phantom_evaluator_template.js.erb"
  PHANTOM_EXECUTOR_SCRIPT_TEMPLATE_PATH = "evaluator_templates/phantom_executor_template.sh.erb"
  PHANTOM_UTIL_PATH = "evaluator_templates/phantom-util.js"

  def evaluate
    host = "http://127.0.0.1"
    port = 8080

    solution_files_paths = create_solution_files
    evaluation_file_path = create_evaluation_file(host,port)
    executor_script_path = create_executor_file(evaluation_file_path,port)

    FileUtils.chmod(0777,executor_script_path[:local_path])

    command = [
      "docker", "run", "-d", "-v", "#{tmp_path}:#{container_path}", "makeitrealcamp/mir-evaluator",
      "/bin/bash", "-c", "-l",
      "#{executor_script_path[:container_path]}"].join(" ")

    execution = DockerExecution.new(command,solution.challenge.timeout)
    execution.start!
    if execution.success?
      complete(solution)
    else
      if File.exist?(error_shared_path[:local_path]) && !File.read(error_shared_path[:local_path]).empty?
        handle_error(solution, error_shared_path[:local_path])
      else
        fail(solution, "La evaluación falló por un problema desconocido :S. Repórtalo a tu mentor o a info@makeitreal.camp indicando el tema y el reto donde ocurrió el error.")
      end
    end
  rescue SimpleTimeout::Error
    fail_timeout(solution)
  rescue Exception => unknown_error
    fail_unknown(solution,unknown_error)
  ensure
    File.delete(error_shared_path[:local_path]) if File.exist?(error_shared_path[:local_path])
  end

  protected

    def create_phantom_util_file
      content = File.read(PHANTOM_UTIL_PATH)
      create_shared_file("phantom_util.js",content)
    end

    def create_evaluation_file(host, port)
      template = File.read(PHANTOM_EVALUATOR_TEMPLATE_PATH)
      # required for template: host,port,phantom_util_path
      phantom_util_path = create_phantom_util_file[:container_path]

      evaluation = self.solution.challenge.evaluation

      evaluator_content = ERB.new(template).result(binding)
      evaluator_content += "\n" + evaluation + "\n" + "evaluate(0);"

      create_shared_file("evaluation.js",evaluator_content)
    end

    def create_executor_file(evaluation_shared_path,port)
      template = File.read(PHANTOM_EXECUTOR_SCRIPT_TEMPLATE_PATH)
      # required for template: evaluation_file_path, error_file_path,port,solution_files_folder
      evaluation_file_path = evaluation_shared_path[:container_path]
      error_file_path = error_shared_path[:container_path]
      solution_files_folder = solution_files_shared_folder[:container_path]
      executor_content = ERB.new(template).result(binding)
      create_shared_file("executor.sh",executor_content)
    end

end
