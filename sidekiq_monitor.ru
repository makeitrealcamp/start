
if ENV["SIDEKIQ_MONITOR_USERNAME"].nil? || ENV["SIDEKIQ_MONITOR_PASSWORD"].nil?
  raise '$SIDEKIQ_MONITOR_USERNAME and $SIDEKIQ_MONITOR_PASSWORD required'
end

require 'sidekiq'
require 'sidekiq/web'

Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end

map '/sidekiq' do
  use Rack::Auth::Basic, "Protected Area" do |username, password|
    username == ENV["SIDEKIQ_MONITOR_USERNAME"] && password == ENV["SIDEKIQ_MONITOR_PASSWORD"]
  end
  run Sidekiq::Web
end
