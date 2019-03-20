class Evaluator::Ruby < Evaluator::Base
  EVALUATOR_PATH = "evaluator_templates/ruby/evaluator.rb.erb"
  EXECUTOR_PATH = "evaluator_templates/ruby/executor.sh.erb"

  def initialize(solution)
    @solution = solution
  end

  def prepare
    create_evaluation_file
    create_executor_file
    FileUtils.chmod(0777, "#{local_path}/executor.sh")
  end

  def execute
    image = "makeitrealcamp/mir-evaluator"
    command = [
      "docker", "run", "-d", "-v", "#{local_path}:#{container_path}", image,
      "/bin/bash", "-c", "-l", "#{container_path}/executor.sh"
    ].join(" ")

    cid = Evaluator::Docker.execute(command)
    ok = Evaluator::Docker.wait(cid, @solution.challenge.timeout)

    puts "Ok: #{ok}"
    ok ? complete : failure
  rescue SimpleTimeout::Error
    fail_timeout
  end

  def clean
    FileUtils.rm_rf(local_path)
  end

  private
    def create_evaluation_file
      template = File.read(EVALUATOR_PATH)

      # required for template: evaluation, solution_file_paths
      solution_files = create_solution_files
      solution_files_paths = solution_files.map { |n| "#{container_path}/#{n}" }

      evaluation = @solution.challenge.evaluation
      evaluator_content = ERB.new(template).result(binding)
      create_file(local_path, "evaluation.rb", evaluator_content)
    end

    def create_executor_file
      template = File.read(EXECUTOR_PATH)

      # required for template: evaluation_file_path, error_file_path
      evaluation_file_path = "#{container_path}/evaluation.rb"
      error_file_path = "#{container_path}/error.txt"

      executor_content = ERB.new(template).result(binding)
      create_file(local_path, "executor.sh", executor_content)
    end

    def failure
      puts "Failure!"
      f = "#{local_path}/error.txt"
      if File.exist?(f) && !File.read(f).empty?
        handle_error(f)
      else
        fail("La evaluación falló por un problema desconocido :S\n\n Repórtalo a tu mentor o a info@makeitreal.camp enviando el URL con tu solución e indicando el tema y reto donde ocurrió.")
      end
    end

    def handle_error(error_file)
      message = File.read(error_file)
      message = message.gsub("/ukku/data/", "")
      fail(message.truncate(450))
    end
end
