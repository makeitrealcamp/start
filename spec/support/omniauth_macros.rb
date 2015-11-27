module OmniauthMacros
  # The mock_auth configuration allows you to set per-provider (or default)
  # authentication hashes to return during integration testing.
  def mock_auth_hash_slack(user)
    OmniAuth.config.mock_auth[:slack] = OmniAuth::AuthHash.new({
      provider: 'slack',
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
end
