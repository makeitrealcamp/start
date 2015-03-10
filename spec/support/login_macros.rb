module LoginMacros
  def login(user)
    visit root_path
    click_link 'Ingresar'
    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    click_button 'Ingresar'
  end
end
