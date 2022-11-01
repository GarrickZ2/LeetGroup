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
    uid = UserHelper.login params[:username], params[:password]
    unless uid.positive?
      flash[:l_notice] = 'Username or password is incorrect'
      redirect_to user_index_path type: 'login'
      return
    end
    session[:uid] = uid
    session[:profile] = UserProfile.get_profile uid
    session[:email] = UserHelper.get_user_log_info(uid)[1]
    redirect_to main_dashboard_path
  end

  def logout
    session.delete :uid
    session.delete :profile
    session.delete :email
    flash[:l_notice] = 'You have been logged out.'
    redirect_to user_index_path type: 'login'
  end

  def save_avatar
    uid = params[:uid]
    if uid.nil? || uid.to_i != session[:uid] || session[:temp_avatar].nil?
      # uid is invalid
      flash[:main_notice] = 'Save Avatar Failed'
    else
      extension = session[:temp_avatar].split('.')[1]
      flash[:main_notice] = 'Save Avatar success'
      new_path = Rails.root.join('public', 'avatar', "#{uid}.#{extension}")
      saved_path = "/avatar/#{uid}.#{extension}"
      FileUtils.mv(session[:temp_avatar], new_path)
      res = UserHelper.update_avatar(uid, saved_path)
      flash[:main_notice] = (res ? 'Save successfully' : 'Save Avatar Failed')
      session[:profile] = UserHelper.get_profile(uid)
    end
    redirect_to '/main/profile'
  end

  def upload_avatar
    avatar = params[:file]
    file_path = ''
    File.open(Rails.root.join('public', 'avatar', 'temp', avatar.original_filename), 'wb') do |file|
      file.write(avatar.read)
      file_path = file.path
    end
    session[:temp_avatar] = file_path
    render json: { success: true, msg: nil }
  end

  def update_profile
    user = UserProfile.new
    p params
    user.uid = params[:uid]
    # user.username = params[:username]
    user.company = params[:company]
    user.role = params[:role]
    user.school = params[:school]
    user.city = params[:city]
    user.bio = params[:bio]
    p user
    # update
    res = UserHelper.update_profile(user)
    if res
      session[:main_notice] = 'Save Profile Successfully'
      session[:profile] = UserHelper.get_profile user.uid
      session[:email] = UserHelper.get_user_log_info(user.uid)[1]
    else
      session[:main_notice] = 'Save Profile Failed'
    end
    redirect_to '/main/profile'
  end
end
