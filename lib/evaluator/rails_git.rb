class Evaluator::RailsGit < Evaluator::Base
  TEMPLATE_PATH = "evaluator_templates/rails_git/template.rb"
  EXECUTOR_PATH = "evaluator_templates/rails_git/executor.sh.erb"

  def initialize(solution)
    @solution = solution
  end

  def prepare
    # check if repository exists
    if !Octokit.repository?(@solution.repository)
      fail("No se encontró el repositorio #{@solution.repository}")
      return
    end

    # write spec file and rails app template
    create_file(local_path, "makeitreal_spec.rb", @solution.challenge.evaluation)
    create_file(local_path, "rails_template.rb", File.read(TEMPLATE_PATH))

    create_executor_file
    FileUtils.chmod(0777, "#{local_path}/executor.sh")
  end

  def execute
    image = "makeitrealcamp/mir-evaluator"
    repo = "https://github.com/#{@solution.repository}"
    command = [
      "docker", "run", "-d", "-v", "#{local_path}:#{container_path}",
      "-v", "#{base_path}/bundler-cache:/ukku/bundler-cache",
      image, "/bin/bash", "-c", "-l", "'#{container_path}/executor.sh #{repo}'"]

    cid = Evaluator::Docker.execute(command.join(" "))
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
        fail("La evaluación falló por un problema desconocido :S\n\n Repórtalo a tu mentor o a info@makeitreal.camp enviando el URL con tu solución e indicando el tema y el reto donde ocurrió.")
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
