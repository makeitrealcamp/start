class Evaluator::Express < Evaluator::Base
  EVALUATOR_PATH = "evaluator_templates/express/evaluator.js.erb"
  EXECUTOR_PATH = "evaluator_templates/express/executor.sh.erb"

  def initialize(solution)
    @solution = solution
  end

  def prepare
    # check if repository exists
    if !Octokit.repository?(@solution.repository)
      fail("No se encontró el repositorio #{@solution.repository}")
      return
    end

    create_evaluation_file
    create_executor_file
    FileUtils.chmod(0777, "#{local_path}/executor.sh")
  end

  def execute
    unless Evaluator::Docker.exists("mongodb")
      Evaluator::Docker.execute("docker run --name mongodb -d mongo:4.1-xenial")
    end

    image = "makeitrealcamp/node-evaluator"
    repo = "https://github.com/#{@solution.repository}"
    command = [
      "docker", "run", "-d", "--link", "mongodb:mongodb", "-v", "#{local_path}:#{container_path}", image,
      "/bin/bash", "-c", "-l", "'#{container_path}/executor.sh #{repo}'"
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
      # required for template: evaluation
      evaluation = @solution.challenge.evaluation
      evaluator_content = ERB.new(template).result(binding)
      create_file(local_path, "app.test.js", evaluator_content)
    end

    def create_executor_file
      template = File.read(EXECUTOR_PATH)
      # required for template: evaluation_file_path, error_file_path
      evaluation_file_path = "#{container_path}/app.test.js"
      result_file_path = "#{container_path}/result.json"
      error_file_path = "#{container_path}/error.txt"
      user_id = @solution.user.id

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
      puts result_file
      result = JSON.parse(result_file)

      failures = result["stats"]["failures"]
      if failures > 0
        message = "#{result["failures"][0]["err"]["message"]}"
        fail(message)
      end
    end
end
