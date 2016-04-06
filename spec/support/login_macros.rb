module LoginMacros
  def login(user)
    mock_auth_hash_slack(user)

    visit login_path
    find('#sign-in-slack').click

    path = if user.status == "active"
      signed_in_root_path
    elsif user.status == "suspended"
      root_path
    else
      activate_users_path
    end
    
    expect(current_path).to eq(path)
  end
end
