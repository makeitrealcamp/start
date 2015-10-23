class RubyEvaluator < BaseDockerEvaluator

  RUBY_EVALUATOR_TEMPLATE_PATH = "evaluator_templates/ruby_evaluator_template.rb.erb"
  RUBY_EXECUTOR_TEMPLATE_PATH = "evaluator_templates/ruby_executor_template.sh.erb"

  def evaluate

    solution_files_paths = create_solution_files
    evaluation_file_path = create_evaluation_file(solution_files_paths)
    executor_script_path = create_executor_file(evaluation_file_path)

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
        fail(solution, "La evaluación falló por un problema desconocido :S. Repórtalo a info@makeitreal.camp enviando el URL con tu solución.")
      end
    end
  rescue SimpleTimeout::Error
    fail_timeout(solution)
  rescue Exception => unknown_error
    fail_unknown(solution,unknown_error)
  ensure
    # File.delete("#{tmp_path}/error.txt") if File.exist?("#{tmp_path}/error.txt")
  end

  private

    def create_evaluation_file(shared_paths)
      template = File.read(RUBY_EVALUATOR_TEMPLATE_PATH)
      # required for template: evaluation, solution_file_paths
      solution_files_paths = shared_paths.map { |f| f[:container_path] }
      evaluation = self.solution.challenge.evaluation
      evaluator_content = ERB.new(template).result(binding)
      create_shared_file("evaluation.rb",evaluator_content)
    end

    def create_executor_file(shared_path)
      template = File.read(RUBY_EXECUTOR_TEMPLATE_PATH)
      # required for template: evaluation_file_path, error_file_path
      evaluation_file_path = shared_path[:container_path]
      error_file_path = error_shared_path[:container_path]

      executor_content = ERB.new(template).result(binding)
      create_shared_file("executor.sh",executor_content)
    end
end
