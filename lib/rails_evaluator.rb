class RailsEvaluator < Evaluator
  def evaluate(solution)
    if !Octokit.repository?(solution.repository)
      fail(solution, "No se encontró el repositorio #{solution.repository}")
      return
    end

    dirname = "#{ENV['HOME']}/.ukku/shared/tmp/rails/user-#{solution.user_id}/solution-#{solution.id}"
    FileUtils.rm_rf(dirname)
    FileUtils.mkdir_p dirname

    File.open("#{dirname}/makeitreal_spec.rb", 'w') { |file| file.write(solution.challenge.evaluation) }
    FileUtils.cp("lib/rails_template.rb", dirname)

    repo = "https://github.com/#{solution.repository}"
    # container = Docker::Container.create('Image' => 'germanescobar/ruby-evaluator', 'Cmd' => ['/bin/bash', '-l', '-c', "/root/run.sh #{repo}"], 'Volumes' => { "/ukku/data" => {}, "/ukku/bundler-cache" => {} }, 'HostConfig' => { "Binds" => ["#{dirname}:/ukku/data", "#{ENV['HOME']}/.ukku/shared/bundler-cache:/ukku/bundler-cache"] })
    # container.start
    # status_code = container.wait(300)["StatusCode"]
    status = Subprocess.call(["docker", "run", "-v", "#{dirname}:/ukku/data", "-v", "#{ENV['HOME']}/.ukku/shared/bundler-cache:/ukku/bundler-cache", "germanescobar/ruby-evaluator", "/bin/bash", "-c", "-l", "/root/run.sh #{repo}"])
    if status.success?
      complete(solution)
    else
      result_file = File.read("#{dirname}/result.json")
      result = JSON.parse(result_file)
      tests = result["examples"].reject { |test| test["status"] != "failed" }

      test = tests[0]
      message = "#{test['exception']['message']}"
      fail(solution, message)
    end

  rescue Exception => e
    puts e.message
    puts e.backtrace

    fail(solution, "Hemos encontrado un error en el evaluador, favor reportar a info@makeitreal.camp: #{e.message}".truncate(250))
  end
end