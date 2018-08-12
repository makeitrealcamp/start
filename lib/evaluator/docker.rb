class Evaluator::Docker
  def self.execute(command)
    puts "******* Command: #{command} *******"
    id = `#{command}`.strip
    puts "******* DOCKER_ID: #{id} *******"
    id
  end

  def self.wait(id, timeout)
    SimpleTimeout::timeout(timeout) do
      system "docker logs -f --tail='all' #{id}"
      `docker wait #{id}`.strip == "0"
    end
  rescue SimpleTimeout::Error => e
    system "docker kill #{id}"
    raise e.class, e.message
  ensure
    system "docker rm #{id}"
  end

  def self.exists(name)
    system `docker inspect -f '{{.State.Running}}' #{name}`
  end
end
