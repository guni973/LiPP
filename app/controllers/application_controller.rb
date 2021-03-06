# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  helper_method :current_user, :logged_in?

  def home; end

  protected

  def current_user
    return unless session[:user_id]

    @current_user ||= User.find(session[:user_id])
  end

  private

  def logged_in?
    !!session[:user_id]
  end

  def authenticate
    return if logged_in?

    redirect_to root_path, alert: 'ログインしてください'
  end
end
