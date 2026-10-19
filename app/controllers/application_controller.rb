class ApplicationController < ActionController::Base
  before_action :require_login, if: :admin_namespace?

  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    unless logged_in?
      flash[:alert] = "Entre na sua conta para acessar o painel de voluntários."
      redirect_to login_path
    end
  end

  private

  def admin_namespace?
    controller_path.start_with?("admin/")
  end
end
