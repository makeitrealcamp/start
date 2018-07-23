class SinatraEvaluator < BaseDockerEvaluator

  SPEC_HELPER_PATH = "templates/spec_helper.rb"

  def evaluate
    # check if repository exists
    if !Octokit.repository?(solution.repository)
      fail(solution, "No se encontró el repositorio #{solution.repository}")
      return
    end

    # write spec file and spec_helper
    create_shared_file("makeitreal_spec.rb", solution.challenge.evaluation)
    create_shared_file("spec_helper.rb", File.read(SPEC_HELPER_PATH))

    repo = "https://github.com/#{solution.repository}"
    command = [
      "docker", "run", "-d","-v", "#{tmp_path}:#{container_path}", "makeitrealcamp/mir-evaluator",
      "/bin/bash", "-c", "-l", "'/root/sinatra.sh #{repo}'"
    ].join(" ")

    execution = DockerExecution.new(command, solution.challenge.timeout)
    execution.start!

    if execution.success?
      complete(solution)
    else
      if File.exist?(error_shared_path[:local_path]) && !File.read(error_shared_path[:local_path]).empty?
        handle_error(solution, error_shared_path[:local_path])
      elsif File.exist?(result_shared_path[:local_path])
        handle_test_failure(solution, result_shared_path[:local_path])
      else
        fail(solution, "La evaluación falló por un problema desconocido :S\n\nRepórtalo a tu mentor o a info@makeitreal.camp enviando el URL con tu solución e indicando el tema y el reto donde ocurrió: " + status.to_s)
      end

    end
  rescue SimpleTimeout::Error
    fail_timeout(solution)
  rescue Exception => unknown_error
    fail_unknown(solution,unknown_error)
  ensure
    File.delete(error_shared_path[:local_path]) if File.exist?(error_shared_path[:local_path])
    File.delete(result_shared_path[:local_path]) if File.exist?(result_shared_path[:local_path])
  end
end
