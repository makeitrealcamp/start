class SinatraEvaluator < BaseDockerEvaluator
  def evaluate(solution)
    # check if repository exists
    if !Octokit.repository?(solution.repository)
      fail(solution, "No se encontró el repositorio #{solution.repository}")
      return
    end

    tmp_path = create_tmp_path(solution)

    # write spec file and spec_helper
    File.open("#{tmp_path}/makeitreal_spec.rb", 'w') { |file| file.write(solution.challenge.evaluation) }
    FileUtils.cp("lib/spec_helper.rb", tmp_path)

    repo = "https://github.com/#{solution.repository}"
    status = Subprocess.call(["docker", "run", "-v", "#{tmp_path}:/ukku/data", "germanescobar/ruby-evaluator", "/bin/bash", "-c", "-l", "/root/sinatra.sh #{repo}"])
    if status.success?
      complete(solution)
    else
      if File.exist?("#{tmp_path}/error.txt") && !File.read("#{tmp_path}/error.txt").empty?
        handle_error(solution, "#{tmp_path}/error.txt")
      elsif File.exist?("#{tmp_path}/result.json")
        handle_test_failure(solution, "#{tmp_path}/result.json")
      else
        fail(solution, "La evaluación falló por un problema desconocido :S. Repórtalo a info@makeitreal.camp enviando el URL con tu solución: " + status.to_s)
      end

    end
  rescue Exception => e
    puts e.message
    puts e.backtrace

    fail(solution, "Hemos encontrado un error en el evaluador, favor reportar a info@makeitreal.camp: #{e.message}".truncate(250))
  ensure
    # File.delete("#{tmp_path}/error.txt") if File.exist?("#{tmp_path}/error.txt")
    # File.delete("#{tmp_path}/result.json") if File.exist?("#{tmp_path}/result.json")
  end
end
