class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def sign_in(user)
    cookies.permanent.signed[:user_id] = user.id
    @current_user = user
  end

  def sign_out
    cookies.delete(:user_id)
    @current_user = nil
  end

  private
    def signed_in?
      !current_user.nil?
    end
    helper_method :signed_in?

    def current_user
      @current_user ||= User.find(cookies.signed[:user_id]) if cookies.signed[:user_id]
    end
    helper_method :current_user

    def public_access
      redirect_to :dashboard if signed_in?
    end

    def private_access
      redirect_to :login unless signed_in?
    end
end
