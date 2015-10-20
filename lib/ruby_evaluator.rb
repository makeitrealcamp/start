class RubyEvaluator < BaseDockerEvaluator

  RUBY_EVALUATOR_TEMPLATE_PATH = "evaluator_templates/ruby_evaluator_template.rb.erb"
  RUBY_EXECUTOR_TEMPLATE_PATH = "evaluator_templates/ruby_executor_template.sh.erb"

  def evaluate

    solution_files_paths = create_solution_files
    evaluation_file_path = create_evaluation_file(solution_files_paths)
    executor_script_path = create_executor_file(evaluation_file_path)

    FileUtils.chmod(0777,executor_script_path[:local_path])

    status = Subprocess.call([
      "docker", "run", "-v", "#{tmp_path}:#{container_path}", "germanescobar/ruby-evaluator",
      "/bin/bash", "-c", "-l",
      "#{executor_script_path[:container_path]}"])

    if status.success?
      complete(solution)
    else
      if File.exist?(error_shared_path[:local_path]) && !File.read(error_shared_path[:local_path]).empty?
        handle_error(solution, error_shared_path[:local_path])
      else
        fail(solution, "La evaluación falló por un problema desconocido :S. Repórtalo a info@makeitreal.camp enviando el URL con tu solución.")
      end
    end
  rescue Exception => e
    puts e.message
    puts e.backtrace

    fail(solution, "Hemos encontrado un error en el evaluador, favor reportar a info@makeitreal.camp: #{e.message}".truncate(250))
  ensure
    # File.delete("#{tmp_path}/error.txt") if File.exist?("#{tmp_path}/error.txt")
  end

  def create_solution_files
    solution.documents.map do |document|
      create_shared_file(
        relative_path: File.join("solution_files",document.name),
        content: document.content
      )
    end
  end

  def create_evaluation_file(shared_paths)
    template = File.read(RUBY_EVALUATOR_TEMPLATE_PATH)
    # required for template: evaluation, solution_file_paths
    solution_files_paths = shared_paths.map { |f| f[:container_path] }
    evaluation = self.solution.challenge.evaluation
    evaluator_content = ERB.new(template).result(binding)
    create_shared_file(
      relative_path: "evaluation.rb",
      content: evaluator_content
    )
  end

  def create_executor_file(shared_path)
    template = File.read(RUBY_EXECUTOR_TEMPLATE_PATH)
    # required for template: evaluation_file_path, error_file_path
    evaluation_file_path = shared_path[:container_path]
    error_file_path = error_shared_path[:container_path]

    executor_content = ERB.new(template).result(binding)
    create_shared_file(
      relative_path: "executor.sh",
      content: executor_content
    )
  end

end
