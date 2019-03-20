class Evaluator::Base
  def base_path
    Rails.env.production? ? "/app/tmp/ukku" : File.expand_path("~/.ukku")
  end

  def local_path
    @local_path ||= create_local_path
  end

  def container_path
    "/ukku/data"
  end

  def create_solution_files(path=local_path)
    @solution.documents.map do |document|
      create_file(path, document.name, document.content)
      document.name
    end
  end

  def create_file(path, name, content)
    abs_path = File.join(path, name)

    unless File.directory?(path)
      FileUtils.mkdir_p(path)
    end

    File.open(abs_path, 'w') do |file|
      file.write(content)
    end
  end

  def fail(message)
    @solution.status = :failed
    @solution.error_message = message
    @solution.save!
  end

  def complete
    puts "Complete!"
    @solution.status = :completed
    @solution.completed_at = DateTime.current
    @solution.error_message = nil
    @solution.save!
  end

  def fail_timeout
    fail("Se ha exedido el tiempo máximo de ejecución de esta solución. Verifica que no haya ciclos infinitos en tu código.")
  end

  def fail_unknown(error)
    message = "Hemos encontrado un error en el evaluador, favor reportar a tu mentor:\n\n"
    message += "#{error.message}: \n"
    message += "\t#{error.backtrace.join("\n\t")}"
    message = message.gsub("/ukku/data/", "")
    fail(message.truncate(650))
  end

  def handle_error(error_path)
    message = File.read(error_path)
    message = message.gsub("/ukku/data/", "")
    fail(message.truncate(450))
  end

  private
    def create_local_path
      evaluator_folder = self.class.name.demodulize.underscore
      create_solution_path("#{base_path}/#{evaluator_folder}")
    end

    def create_solution_path(path)
      if !File.exist?(path)
        FileUtils.mkdir_p(path)
        FileUtils.chmod_R(0777, path)
      end

      path = File.join(path, "user#{@solution.user_id}-solution#{@solution.id}")

      FileUtils.rm_rf(path)
      FileUtils.mkdir(path)
      FileUtils.chmod(0777, path)
      path
    end
end
