class Evaluator::Sinatra < Evaluator::Base
  EXECUTOR_PATH = "evaluator_templates/sinatra/executor.sh.erb"
  SPEC_HELPER_PATH = "evaluator_templates/sinatra/spec_helper.rb"

  def initialize(solution)
    @solution = solution
  end

  def prepare
    # check if repository exists
    if !Octokit.repository?(@solution.repository)
      fail("No se encontró el repositorio #{@solution.repository}")
      return
    end

    create_file(local_path, "makeitreal_spec.rb", @solution.challenge.evaluation)
    create_file(local_path, "spec_helper.rb", File.read(SPEC_HELPER_PATH))

    create_executor_file
    FileUtils.chmod(0777, "#{local_path}/executor.sh")
  end

  def execute
    image = "makeitrealcamp/mir-evaluator"
    repo = "https://github.com/#{@solution.repository}"
    command = [
      "docker", "run", "-d","-v", "#{local_path}:#{container_path}", image,
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
    def create_executor_file
      template = File.read(EXECUTOR_PATH)
      # required for template: evaluation_file_path, error_file_path
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
        fail("La evaluación falló por un problema desconocido :S\n\nRepórtalo a tu mentor o a info@makeitreal.camp enviando el URL con tu solución e indicando el tema y el reto donde ocurrió")
      end
    end

    def handle_test_failure(result_path)
      result_file = File.read(result_path)
      result = JSON.parse(result_file)
      tests = result["examples"].reject { |test| test["status"] != "failed" }

      test = tests[0]
      message = "La aplicación #{test['description']}:\n\n\t#{test['exception']['message']}"
      fail(message)
    end
end
