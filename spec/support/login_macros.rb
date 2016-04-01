module LoginMacros
  def login(user)
    mock_auth_hash_slack(user)
    
    visit login_path
    find('#sign-in-slack').click

    path = user.status == "active" ? signed_in_root_path : activate_users_path
    expect(current_path).to eq(path)
  end
end
