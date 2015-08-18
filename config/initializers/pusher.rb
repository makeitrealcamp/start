require 'pusher'

Pusher.url = ENV["PUSHER_URL"] || "https://f0cdd27277f814b8b785:694e058164096f2e52ec@api.pusherapp.com/apps/136453"
Pusher.logger = Rails.logger
