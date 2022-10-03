Split.configure do |config|
  config.allow_multiple_experiments = true
  config.persistence = :cookie
  config.persistence_cookie_length = 2592000 # 30 days
  config.redis = ENV['REDISCLOUD_URL'] || 'redis://localhost:6379'
end