class RubyEvaluator < Evaluator
  def evaluate(solution)
    tmp_path = create_tmp_path(solution)

    # write solution files
    files_paths = solution.documents.map do |document|
      file_path = "#{tmp_path}/#{document.name}"
      File.open(file_path, 'w') do |file|
        file.write(document.content)
      end
      "/ukku/data/#{document.name}"
    end

    # create evaluation file content
    evaluation_file = %Q(
      class Context
        def self.eval(file)
          c = Context.new
          c.instance_eval(file)
          c
        end
      end
      # wrapper of file to mantain compatibility with previous evaluator
      class SolutionFile
        attr_accessor :content
        def initialize(content)
          self.content = content
        end
      end

      def format_exception(message)
        message.gsub(/for #<Context:.*>/i, '').gsub(/\\(eval\\)\\:/i, '')
      end

      #{solution.challenge.evaluation} # define evaluate method

      files = #{files_paths.inspect}.each_with_object({}) do |path,hash|
        file = File.open(path, "rb")
        hash[File.basename(path)] = SolutionFile.new(file.read)
        file.close
      end
      print evaluate(files)
    )

    # write evaluation file
    evaluation_file_path = "#{tmp_path}/evaluation_#{SecureRandom.hex}.rb"
    File.open("#{evaluation_file_path}", 'w') do |file|
      file.write(evaluation_file)
    end
    # create executor_script
    executor_script = %Q(
      #!/bin/bash

      set -e
      set -x

      if [ ! -f $1 ]; then
        echo "No se encontró el archivo de evaluación #{evaluation_file_path}." >> /ukku/data/error.txt
        exit 1
      fi
      ruby $1 &> /ukku/data/error.txt

      if [ -s /ukku/data/error.txt ]
      then
        exit 1
      fi
    )
    executor_script_path = "#{tmp_path}/ruby_#{SecureRandom.hex}.sh"
    File.open("#{executor_script_path}", 'w') do |file|
      file.write(executor_script)
    end
    FileUtils.chmod(0777,executor_script_path)

    status = Subprocess.call(["docker", "run", "-v", "#{tmp_path}:/ukku/data", "germanescobar/ruby-evaluator", "/bin/bash", "-c", "-l", "/ukku/data/#{File.basename(executor_script_path)} /ukku/data/#{File.basename(evaluation_file_path)}"])
    if status.success?
      complete(solution)
    else
      if File.exist?("#{tmp_path}/error.txt") && !File.read("#{tmp_path}/error.txt").empty?
        handle_error(solution, "#{tmp_path}/error.txt")
      else
        fail(solution, "La evaluación falló por un problema desconocido :S. Repórtalo a info@makeitreal.camp enviando el URL con tu solución.")
      end
    end
  rescue Exception => e
    puts e.message
    puts e.backtrace

    fail(solution, "Hemos encontrado un error en el evaluador, favor reportar a info@makeitreal.camp: #{e.message}".truncate(250))
  ensure
    # File.delete("#{tmp_path}/error.txt") if File.exist?("#{tmp_path}/error.txt")
  end

  def prefix_path
    # we need change the prefix in development because boot2docker only shares de /Users path, not /tmp
    Rails.env.production? ? "/app/tmp/ukku" : File.expand_path('~/.ukku')
  end

  def create_tmp_path(solution)
    if !File.exist?("#{prefix_path}/ruby")
      FileUtils.mkdir_p("#{prefix_path}/ruby")
      FileUtils.chmod_R(0777, "#{prefix_path}/ruby")
    end

    path = "#{prefix_path}/ruby/user#{solution.user_id}-solution#{solution.id}"

    FileUtils.rm_rf(path)
    FileUtils.mkdir(path)
    FileUtils.chmod(0777, path)

    path
  end

  def handle_error(solution, error_path)
    fail(solution, File.read(error_path).truncate(255))
  end

end
