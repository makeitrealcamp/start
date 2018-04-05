module LoginMacros
  def login(user)
    mock_auth_hash_slack(user)

    visit login_path
    find('#sign-in-slack').click

    path = if user.created?
      activate_users_path
    elsif user.suspended?
      login_path
    else # active or finished
      signed_in_root_path
    end

    wait_for { current_path }.to eq(path)
  end

  def login_password(user)
    visit login_onsite_path

    fill_in "email", with: user.email
    fill_in "password", with: user.password

    level = create(:level)
    click_on "Ingresar"

    path = if user.created?
      activate_users_path
    elsif user.suspended?
      login_path
    else # active or finished
      signed_in_root_path
    end

    expect(current_path).to eq(path)
  end
end
