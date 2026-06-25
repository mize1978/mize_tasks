class ApplicationController < ActionController::Base
  before_action :require_login
  before_action :require_egg_color

  helper_method :current_user

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  private

  def require_login
    return if session[:user_id]
    redirect_to login_path, alert: "ログインしてください"
  end

  def require_egg_color
    return unless current_user
    return if current_user.egg_color.present?
    return if controller_name == "egg_colors"
    return if controller_name == "sessions"
    redirect_to choose_egg_path
  end
end