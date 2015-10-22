module LoginMacros
  def login(user)
    mock_auth_hash_slack(user)
    visit root_path
    click_link 'Ingresar'
    find('#sign-in-slack').click
  end
end
