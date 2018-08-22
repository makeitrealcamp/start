class Evaluator::Nodejs < Evaluator::Base
  EVALUATOR_PATH = "evaluator_templates/nodejs/evaluator.js.erb"
  EXECUTOR_PATH = "evaluator_templates/nodejs/executor.sh.erb"

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
      solution_files = create_solution_files("#{local_path}/solution_files")
      solution_file_paths = solution_files.map { |n| "#{container_path}/solution_files/#{n}" }
      evaluation = @solution.challenge.evaluation

      evaluator_content = ERB.new(template).result(binding)
      create_file(local_path, "test.js", evaluator_content)
    end

    def create_executor_file
      template = File.read(EXECUTOR_PATH)

      # required for template: evaluation_file_path, error_file_path
      evaluation_file_path = "#{container_path}/test.js"
      result_file_path = "#{container_path}/result.json"
      error_file_path = "#{container_path}/error.txt"

      executor_content = ERB.new(template).result(binding)
      create_file(local_path, "executor.sh", executor_content)
    end

    def failure
      f = "#{local_path}/error.txt"
      if File.exist?(f) && !File.read(f).empty?
        handle_error(f)
      elsif File.exist?("#{local_path}/result.json")
        handle_test_failure("#{local_path}/result.json")
      else
        fail("La evaluación falló por un problema desconocido :S. Repórtalo a tu mentor o a info@makeitreal.camp indicando el tema y el reto donde ocurrió el error.")
      end
    end

    def handle_test_failure(result_path)
      result_file = File.read(result_path)
      result = JSON.parse(result_file)
      tests = result["examples"].reject { |test| test["status"] != "failed" }

      test = tests[0]
      message = "#{test['exception']['message']}"
      fail(message)
    end
end
