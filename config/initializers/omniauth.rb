OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_KEY']    || '418105375034768',
                      ENV['FACEBOOK_SECRET'] || '73f0a02a32d552cf44265539030787f8'

  provider :github, ENV['GITHUB_KEY']    || '4c6d119b1b6060e9286d' ,
                    ENV['GITHUB_SECRET'] || '4d1e77dc92c3bf617e94077a12be4db618e6efe7',
                    scope: "user:email"
end

OmniAuth.config.on_failure = Proc.new do |env|
  SessionsController.action(:omniauth_failure).call(env)
end