class SinatraEvaluator < BaseDockerEvaluator

  SPEC_HELPER_PATH = "lib/spec_helper.rb"

  def evaluate
    # check if repository exists
    if !Octokit.repository?(solution.repository)
      fail(solution, "No se encontró el repositorio #{solution.repository}")
      return
    end

    # write spec file and spec_helper
    create_shared_file("makeitreal_spec.rb",solution.challenge.evaluation)
    create_shared_file("spec_helper.rb",File.read(SPEC_HELPER_PATH))

    repo = "https://github.com/#{solution.repository}"
    status = Subprocess.call([
      "docker", "run", "-v", "#{tmp_path}:#{container_path}", "germanescobar/ruby-evaluator",
      "/bin/bash", "-c", "-l", "/root/sinatra.sh #{repo}"
    ])
    if status.success?
      complete(solution)
    else
      if File.exist?(error_shared_path[:local_path]) && !File.read(error_shared_path[:local_path]).empty?
        handle_error(solution, error_shared_path[:local_path])
      elsif File.exist?(result_shared_path[:local_path])
        handle_test_failure(solution, result_shared_path[:local_path])
      else
        fail(solution, "La evaluación falló por un problema desconocido :S. Repórtalo a info@makeitreal.camp enviando el URL con tu solución: " + status.to_s)
      end

    end
  rescue Exception => e
    puts e.message
    puts e.backtrace

    fail(solution, "Hemos encontrado un error en el evaluador, favor reportar a info@makeitreal.camp: #{e.message}".truncate(250))
  ensure
    # File.delete(error_shared_path[:local_path]) if File.exist?(error_shared_path[:local_path])
    # File.delete(result_shared_path[:local_path]) if File.exist?(result_shared_path[:local_path])
  end
end
