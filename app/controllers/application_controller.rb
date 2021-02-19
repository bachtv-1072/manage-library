class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  include SessionsHelper

  before_action :set_locale

  private
  def render_404
    render file: Rails.root.join("public", "404.html").to_s, layout: false,
           status: :not_found
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def require_login
    return if logged_in?

    flash[:danger] = t ".require_login"
    redirect_to login_url
  end

  def set_ransack_auth_object
    current_user&.admin? ? :admin : nil
  end
end
