# encoding: UTF-8
class Evaluator::Phantom < Evaluator::Base
  EVALUATOR_PATH = "evaluator_templates/phantom/evaluator.js.erb"
  EXECUTOR_PATH = "evaluator_templates/phantom/executor.sh.erb"
  UTIL_PATH = "evaluator_templates/phantom-util.js"

  def initialize(solution)
    @solution = solution
  end

  def prepare
    host = "http://127.0.0.1"
    port = 8080

    create_evaluation_file(host, port)
    create_executor_file(port)
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

  protected
    def create_evaluation_file(host, port)
      template = File.read(EVALUATOR_PATH)

      # required for template: host, port, phantom_util_path
      create_util_file
      phantom_util_path = "#{container_path}/phantom_util.js"

      evaluation = @solution.challenge.evaluation
      evaluator_content = ERB.new(template).result(binding)
      evaluator_content += "\n" + evaluation + "\n" + "evaluate(0);"

      create_file(local_path, "evaluation.js", evaluator_content)
    end

    def create_util_file
      content = File.read(UTIL_PATH)
      create_file(local_path, "phantom_util.js", content)
    end

    def create_executor_file(port)
      template = File.read(EXECUTOR_PATH)
      # required for template: evaluation_file_path, error_file_path,port,solution_files_folder
      evaluation_file_path = "#{container_path}/evaluation.js"
      error_file_path = "#{container_path}/error.txt"

      create_solution_files("#{local_path}/solution_files")
      solution_files_folder = "#{container_path}/solution_files"

      executor_content = ERB.new(template).result(binding)
      create_file(local_path, "executor.sh", executor_content)
    end

    def failure
      f = "#{local_path}/error.txt"
      if File.exist?(f) && !File.read(f).empty?
        handle_error(f)
      else
        fail("La evaluación falló por un problema desconocido :S. Repórtalo a tu mentor o a info@makeitreal.camp indicando el tema y el reto donde ocurrió el error.")
      end
    end
end
