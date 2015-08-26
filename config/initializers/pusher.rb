require 'pusher'

if ENV["PUSHER_URL"]
  Pusher.url = ENV["PUSHER_URL"]
  Pusher.logger = Rails.logger
end
