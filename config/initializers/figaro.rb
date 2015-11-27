if Rails.env == "production"
  Figaro.require_keys(
    'PUSHER_URL',
    'GITHUB_KEY',
    'GITHUB_SECRET',
    'SLACK_KEY',
    'SLACK_SECRET',
    'SLACK_TEAM'
  )
end
