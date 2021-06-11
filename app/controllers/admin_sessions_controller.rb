class AdminSessionsController < ApplicationController
  def new
    render layout: "pages"
  end

  def create
    admin = Admin.find_by(email: params[:email].downcase)

    if admin && admin.authenticate(params[:password])
      admin_sign_in(admin)
      redirect_to admin_root_path
    else
      redirect_to admin_login_path, flash: { error: "No se pudo realizar la autenticación. Revisa tus credenciales e intenta nuevamente." }
    end
  end

  def destroy
    admin_sign_out
    redirect_to root_path
  end
end
