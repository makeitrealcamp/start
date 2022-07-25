class ApplicationController < ActionController::Base
  before_action :record_user_activity
  after_action :set_content_language

  def sign_in(user)
    cookies.permanent.signed[:user_id] = user.id
    @current_user = user
  end

  def admin_sign_in(admin)
    cookies.permanent.signed[:admin_id] = admin.id
    @current_admin = admin
  end

  def sign_out
    cookies.delete(:user_id)
    @current_user = nil
  end

  def admin_sign_out
    cookies.delete(:admin_id)
    @current_admin = nil
  end

  protected
    def signed_in?
      !current_user.nil?
    end
    helper_method :signed_in?

    def admin_signed_in?
      !current_admin.nil?
    end
    helper_method :admin_signed_in?

    def current_user
      @current_user ||= User.find(cookies.signed[:user_id]) if cookies.signed[:user_id]
    rescue ActiveRecord::RecordNotFound
    end
    helper_method :current_user

    def current_admin
      @current_admin ||= Admin.find(cookies.signed[:admin_id]) if cookies.signed[:admin_id]
    rescue ActiveRecord::RecordNotFound
    end
    helper_method :current_admin

    def public_access
      redirect_to signed_in_root_path if signed_in?
    end

    def admin_public_access
      redirect_to admin_root_path if admin_signed_in?
    end

    def activate_access
      redirect_to activate_users_path if current_user.created?
    end

    def private_access
      if signed_in?
        if current_user.suspended?
          sign_out
          redirect_suspended_user
          return
        end
        activate_access and return
      else
        redirect_to :login
      end
    end

    def admin_access
      unless (signed_in? && current_user.is_admin?) || (admin_signed_in? && current_admin && (current_admin.has_role?(controller_name) || controller_name == "dashboard"))
        redirect_to :admin_login
      end
    end

    def paid_access
      if(!current_user.paid_account? && !current_user.is_admin?)
        redirect_to signed_in_root_path, notice: "Debes estar inscrito al programa para acceder a este recurso"
      end
    end

    def owner_or_admin_access(obj,user=nil)
      if current_user.nil?
        raise ActionController::RoutingError.new('Not Found')
      end
      user ||= obj.user
      is_admin = (signed_in? && current_user.is_admin?) || (admin_signed_in? && current_admin.is_admin?)
      is_owner_of_obj = signed_in? && user.id == current_user.id
      if(!is_admin && !is_owner_of_obj)
        raise ActionController::RoutingError.new('Not Found')
      end
    end

    def record_user_activity
      if current_user
        @first_activity = true if current_user.last_active_at.nil?
        current_user.touch :last_active_at
      end
    end

    def set_content_language
      response.headers["Content-Language"] = I18n.locale.to_s
    end

    def redirect_suspended_user
      redirect_to login_path, notice: "Tu cuenta está suspendida. Para reactivarla comunícate con nosotros a info@makeitreal.camp."
    end

end
