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
    session[:profile] = UserHelper.get_profile session[:uid] if session[:profile].nil?
    if session[:profile].nil?
      flash[:l_notice] = 'User Information Invalid, Please Login Again'
      redirect_to user_index_path type: 'login'
    end
  end

  def dashboard; end
  def profile; end
end
