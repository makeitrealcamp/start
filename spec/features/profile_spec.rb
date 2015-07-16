require 'rails_helper'

RSpec.feature "Profile", type: :feature do
  let!(:user) { create(:user) }
  # public access
  # public access + show invitation to join MIR
  # private access
  # private access + show edition options if it's his profile
  # private access + don't show edition options if it's not his profile

  # show h1"Mi perfil" if it's his profile
  # show h1"Perfil de ..." if it's not his profile

  # update visibility of profile

  # profile by default private

  # show user's gravatar

  # switch between public and private -> toggle visibility of share buttons

  
end
