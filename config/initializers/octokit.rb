if ENV['GITHUB_KEY'] && ENV['GITHUB_SECRET']
  Octokit.configure do |c|
    c.client_id = ENV['GITHUB_KEY']
    c.client_secret = ENV['GITHUB_SECRET']
  end
end
