module OmniauthMacros

  # The mock_auth configuration allows you to set per-provider (or default)
  # authentication hashes to return during integration testing.

  def mock_auth_hash_facebook(user)
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      provider: 'facebook',
      uid: '12345',
      info: {
        first_name: user.first_name,
        email: user.email
      },
      credentials: {
        token: '123456',
      }
    })
  end

  def mock_auth_hash_github(user)
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      provider: 'github',
      uid: '12345',
      info: {
        first_name: user.first_name,
        email:  user.email
      },
      credentials: {
        token: '123456',
      }
    })
  end
end
