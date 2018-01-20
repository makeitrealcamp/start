class BaseDockerEvaluator < Evaluator

  attr_accessor :solution

  def initialize(solution = nil)
    self.solution = solution
  end

  def prefix_path
    # we need change the prefix in development because boot2docker only shares de /Users path, not /tmp
    evaluation_folder_name = self.class.name.demodulize.underscore
    if Rails.env.production?
      File.join("/app/tmp/ukku", evaluation_folder_name)
    else
      File.expand_path("~/.ukku/#{evaluation_folder_name}")
    end
  end

  def handle_error(solution, error_path)
    message = File.read(error_path)
    message = message.gsub("/ukku/data/", "")
    fail(solution, message.truncate(450))
  end

  def handle_test_failure(solution, result_path)
    result_file = File.read(result_path)
    result = JSON.parse(result_file)
    tests = result["examples"].reject { |test| test["status"] != "failed" }

    test = tests[0]
    message = "#{test['exception']['message']}"
    fail(solution, message)
  end

  def create_tmp_path
    if !File.exist?(prefix_path)
      FileUtils.mkdir_p(prefix_path)
      FileUtils.chmod_R(0777, prefix_path)
    end

    path = File.join(prefix_path, "user#{solution.user_id}-solution#{solution.id}")

    FileUtils.rm_rf(path)
    FileUtils.mkdir(path)
    FileUtils.chmod(0777, path)

    path
  end

  def tmp_path
    @tmp_path ||= create_tmp_path
  end

  def container_path
    "/ukku/data"
  end

  def error_shared_path
    relative_path = "error.txt"
    {
      relative_path: relative_path,
      local_path: File.join(tmp_path, relative_path),
      container_path: File.join(container_path, relative_path)
    }
  end

  def result_shared_path
    relative_path = "result.json"
    {
      relative_path: relative_path,
      local_path: File.join(tmp_path, relative_path),
      container_path: File.join(container_path, relative_path)
    }
  end

  def create_shared_file(relative_path, content)

    local_path = File.join(tmp_path, relative_path)
    dirname = File.dirname(local_path)

    unless File.directory?(dirname)
      FileUtils.mkdir_p(dirname)
    end

    File.open(local_path, 'w') do |file|
      file.write(content)
    end
    {
      relative_path: relative_path,
      local_path: local_path,
      container_path: File.join(container_path, relative_path)
    }
  end

  def solution_files_shared_folder
    relative_path = "solution_files"
    {
      relative_path: relative_path,
      local_path: File.join(tmp_path,relative_path),
      container_path: File.join(container_path,relative_path)
    }
  end

  def create_solution_files
    solution.documents.map do |document|
      create_shared_file(File.join(solution_files_shared_folder[:relative_path], document.name), document.content)
    end
  end

  class DockerExecution
    attr_accessor :timeout,:command,:docker_id,:success

    def initialize(command,timeout)
      self.timeout = timeout
      self.command = command
    end

    def start!
      self.success = SimpleTimeout::timeout(self.timeout) do
        puts "******* Command: #{self.command} *******"
        self.docker_id = `#{self.command}`.strip
        puts "******* DOCKER_ID: #{self.docker_id} *******"
        system "docker logs -f --tail='all' #{self.docker_id}"
        `docker wait #{self.docker_id}`.strip == "0"
      end
    rescue SimpleTimeout::Error => e
      system "docker kill #{docker_id}"
      raise e.class, e.message
    ensure
      system "docker rm #{docker_id}"
    end

    def success?
      self.success == true
    end
  end
end
