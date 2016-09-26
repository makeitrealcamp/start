class ConvertLoopJob < ActiveJob::Base
  queue_as :default

  def perform(data)
    ConvertLoop.event_logs.send(data)
  end
end
