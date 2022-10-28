# frozen_string_literal: true

# Description
# This class is used to handle user's action including register, login, check profile and edit
class UserController < ApplicationController
  @@logger = LeetLogger.get_logger UserController.name, 'user.log'

  def index
    # if the user has logged in before, directly go to the dashboard
    if !session[:uid].nil? && session[:uid].positive?
      @@logger.info "User #{session[:uid]} has logged in, redirect to main_dashboard"
      redirect_to main_dashboard_path
      return
    end
    @login_type = params[:type]
  end

  def create
    unless UserHelper.check_email_format params[:email]
      flash[:r_notice] = 'Email Format is not correct'
      redirect_to user_index_path type: 'register'
      return
    end
    unless UserHelper.check_password_strong params[:password]
      flash[:r_notice] = 'Password has to contains at least 1 Uppercase, Lowercase letter, 1 digit and 1 special character, and length larger than 8'
      redirect_to user_index_path type: 'register'
      return
    end
    unless UserHelper.check_username_format params[:username]
      flash[:r_notice] = 'Username can only contains letter and digits, length between 6 to 50'
      redirect_to user_index_path type: 'register'
      return
    end
    uid = UserHelper.create_account params[:username], params[:email], params[:password]
    if uid == -1
      flash[:r_notice] = 'Username has been taken, please use another one'
      redirect_to user_index_path type: 'register'
      return
    end
    if uid == -2
      flash[:r_notice] = 'Email is in used, please use another one'
      redirect_to user_index_path type: 'register'
      return
    end
    session[:uid] = uid
    logger.info "User registered successfully with uid #{uid}, params: #{params}"
    redirect_to main_dashboard_path
  end

  def login
    @@logger.info "Receive login info : #{params}"
    uid = login_helper params[:username], params[:password]
    unless uid.positive?
      flash[:l_notice] = 'Username or password is incorrect'
      redirect_to user_index_path type: 'login'
      return
    end
    session[:uid] = uid
    redirect_to main_dashboard_path
  end

  def login_helper(username, password)
    -1
  end

  def logout
    session.delete :uid
    flash[:l_notice] = 'You have been logged out.'
    redirect_to user_index_path type: 'login'
  end
end
