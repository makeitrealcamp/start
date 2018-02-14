class ConvertLoopJob < ActiveJob::Base
  queue_as :default

  def perform(data)
    ConvertLoop.event_logs.send(data)
  rescue => e
    Rails.logger.warn "Couldn't send event log #{data[:name]} to ConvertLoop: #{e.message}"
    Rails.logger.error "Backtrace: \n\t#{e.backtrace.join("\n\t")}"
  end
end
