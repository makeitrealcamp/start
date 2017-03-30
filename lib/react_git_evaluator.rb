class ReactGitEvaluator < BaseDockerEvaluator
  def evaluate
    # check if repository exists
    if !Octokit.repository?(solution.repository)
      fail(solution, "No se encontró el repositorio #{solution.repository}")
      return
    end

    create_shared_file("MirRunner.test.js", solution.challenge.evaluation)

    repo = "https://github.com/#{solution.repository}"
    command = [
      "docker", "run", "-d", "-v", "#{tmp_path}:#{container_path}",
      "-v", "#{prefix_path}/yarn-cache:/ukku/yarn-cache",
      "makeitrealcamp/mir-evaluator", "/bin/bash", "-c", "-l", "'/root/react.sh #{repo}'"]

    execution = DockerExecution.new(command.join(" "), solution.challenge.timeout)
    execution.start!

    if execution.success?
      complete(solution)
    else
      if File.exist?(error_shared_path[:local_path]) && !File.read(error_shared_path[:local_path]).empty?
        handle_error(solution, error_shared_path[:local_path])
      elsif File.exist?(result_shared_path[:local_path])
        handle_test_failure(solution, result_shared_path[:local_path])
      else
        fail(solution, "La evaluación falló por un problema desconocido :S. Repórtalo a tu mentor o a info@makeitreal.camp enviando el URL con tu solución e indicando el tema y el reto donde ocurrió.")
      end

    end

  rescue SimpleTimeout::Error
    fail_timeout(solution)
  rescue Exception => unknown_error
    puts unknown_error.message
    fail_unknown(solution,unknown_error)
  ensure
    File.delete(error_shared_path[:local_path]) if File.exist?(error_shared_path[:local_path])
    File.delete(result_shared_path[:local_path]) if File.exist?(result_shared_path[:local_path])
  end
end
