class BaseDockerEvaluator < Evaluator


  def prefix_path
    # we need change the prefix in development because boot2docker only shares de /Users path, not /tmp
    evaluation_folder_name = self.class.name.demodulize.underscore
    Rails.env.production? ? "/app/tmp/ukku/#{evaluation_folder_name}" : File.expand_path("~/.ukku/#{evaluation_folder_name}")
  end

  def create_tmp_path(solution)
    if !File.exist?("#{prefix_path}")
      FileUtils.mkdir_p("#{prefix_path}")
      FileUtils.chmod_R(0777, "#{prefix_path}")
    end

    path = "#{prefix_path}/user#{solution.user_id}-solution#{solution.id}"

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
