# frozen_string_literal: true

# Description
# Used to redirect to the main page of the website
class MainController < ApplicationController
  layout 'dashboard'
  before_action :auth_check
  def auth_check
    if session[:uid].nil?
      flash[:l_notice] = 'Pleases Login Account'
      redirect_to user_index_path type: 'login'
      return
    end
    if session[:profile].nil?
      session[:profile] = UserHelper.get_profile session[:uid]
    end
    if session[:email].nil?
      session[:email] = UserHelper.get_user_log_info(session[:uid])[1]
    end
  end

  def dashboard; end
  def profile; end
end
