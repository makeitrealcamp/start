class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :record_user_activity

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
    rescue ActiveRecord::RecordNotFound
    end
    helper_method :current_user

    def public_access
      redirect_to courses_path if signed_in?
    end

    def private_access
      redirect_to :login unless signed_in?
    end

    def admin_access
      raise ActionController::RoutingError.new('Not Found') unless signed_in? && current_user.is_admin?
    end

    def paid_access
      #TODO: redirect_to price page
      unless current_user.paid_account? || current_user.is_admin?
        redirect_to "/", notice: "Debes estar inscrito al programa para acceder a este recurso"
      end
    end

    def record_user_activity
      if current_user
        @first_activity = true if current_user.last_active_at.nil?
        current_user.touch :last_active_at
      end
    end
end
