OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
   provider :slack  , ENV['SLACK_KEY']  , ENV['SLACK_SECRET'], scope: "identify,read,post", team: "T03KUKHBV"
end

OmniAuth.config.on_failure = Proc.new do |env|
  SessionsController.action(:omniauth_failure).call(env)
end
