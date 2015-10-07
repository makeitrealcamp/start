class RailsEvaluator < Evaluator
  def evaluate(solution)
    # check if repository exists
    if !Octokit.repository?(solution.repository)
      fail(solution, "No se encontró el repositorio #{solution.repository}")
      return
    end

    tmp_path = create_tmp_path(solution)

    # write spec file and rails app template
    File.open("#{tmp_path}/makeitreal_spec.rb", 'w') { |file| file.write(solution.challenge.evaluation) }
    FileUtils.cp("lib/rails_template.rb", tmp_path)

    repo = "https://github.com/#{solution.repository}"
    status = Subprocess.call(["docker", "run", "-v", "#{tmp_path}:/ukku/data", "-v", "#{prefix_path}/bundler-cache:/ukku/bundler-cache", "germanescobar/ruby-evaluator", "/bin/bash", "-c", "-l", "/root/rails.sh #{repo}"])
    if status.success?
      complete(solution)
    else
      if File.exist?("#{tmp_path}/error.txt") && !File.read("#{tmp_path}/error.txt").empty?
        handle_error(solution, "#{tmp_path}/error.txt")
      elsif File.exist?("#{tmp_path}/result.json")
        handle_test_failure(solution, "#{tmp_path}/result.json")
      else
        fail(solution, "La evaluación falló por un problema desconocido :S. Repórtalo a info@makeitreal.camp enviando el URL con tu solución.")
      end

    end
  rescue Exception => e
    puts e.message
    puts e.backtrace

    fail(solution, "Hemos encontrado un error en el evaluador, favor reportar a info@makeitreal.camp: #{e.message}".truncate(250))
  ensure
    File.delete("#{tmp_path}/error.txt") if File.exist?("#{tmp_path}/error.txt")
    File.delete("#{tmp_path}/result.json") if File.exist?("#{tmp_path}/result.json")
  end

  def prefix_path
    # we need change the prefix in development because boot2docker only shares de /Users path, not /tmp
    Rails.env.production? ? "/app/tmp/ukku" : File.expand_path('~/.ukku')
  end

  def create_tmp_path(solution)
    if !File.exist?("#{prefix_path}/rails")
      FileUtils.mkdir_p("#{prefix_path}/rails")
      FileUtils.chmod_R(0777, "#{prefix_path}/rails")
    end

    path = "#{prefix_path}/rails/user#{solution.user_id}-solution#{solution.id}"

    FileUtils.rm_rf(path)
    FileUtils.mkdir(path)
    FileUtils.chmod(0777, path)

    path
  end

  def handle_error(solution, error_path)
    fail(solution, File.read(error_path).truncate(255))
  end

  def handle_test_failure(solution, result_path)
    result_file = File.read(result_path)
    result = JSON.parse(result_file)
    tests = result["examples"].reject { |test| test["status"] != "failed" }

    test = tests[0]
    message = "#{test['exception']['message']}"
    fail(solution, message)
  end
end
