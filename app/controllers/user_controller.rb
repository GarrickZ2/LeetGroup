# frozen_string_literal: true

# Description
# This class is used to handle user's action including register, login, check profile and edit
class UserController < ApplicationController
  @@logger = LeetLogger.get_logger UserController.name, 'user.log'

  def index
    # if the user has logged in before, directly go to the dashboard
    @login_type = params[:type]
    if @login_type != 'register' && (!session[:uid].nil? && session[:uid].positive?)
      @@logger.info "User #{session[:uid]} has logged in, redirect to main_dashboard"
      flash[:main_notice] = 'Login Already, Login successfully'
      redirect_to main_dashboard_path
      return
    else
      MainHelper.clean_session session
    end
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
    MainHelper.create_session session, uid
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
    MainHelper.create_session session, uid
    redirect_to main_dashboard_path
  end

  def logout
    MainHelper.clean_session session
    if flash[:l_notice].nil?
      flash[:l_notice] = 'You have been logged out.'
    else 
      flash[:l_notice] = flash[:l_notice]
    end
    redirect_to user_index_path type: 'login'
  end

  def save_avatar
    uid = params[:uid]
    index = params[:index]
    if uid.nil? || uid.to_i != session[:uid] || index.nil? || index == '' || index.to_i < 1 || index.to_i > 27
      flash[:main_notice] = 'Save Avatar Failed'
    else
      avatar_path = "/main/assets/images/faces/face#{index}.jpg"
      res = UserHelper.update_avatar(uid, avatar_path)
      flash[:main_notice] = (res ? 'Save successfully' : 'Save Avatar Failed')
      MainHelper.create_session session, uid.to_i
    end
    redirect_to '/main/profile'
  end

  def update_profile
    user = UserProfile.new
    user.uid = params[:uid].to_i
    # user.username = params[:username]
    user.company = params[:company]
    user.role = params[:role]
    user.school = params[:school]
    user.city = params[:city]
    user.bio = params[:bio]
    # update
    res = UserHelper.update_profile(user)
    if res
      flash[:main_notice] = 'Save Profile Successfully'
      MainHelper.create_session session, user.uid
    else
      session[:main_notice] = 'Save Profile Failed'
    end
    redirect_to '/main/profile'
  end

  def update_password
    user = UserHelper.get_user_log_info params[:uid]
    if user[0].nil?
      flash[:main_notice] = 'User doesn\'t exist'
      redirect_to '/main/password'
      return
    end
    if user[0] != params[:o_pass]
      flash[:main_notice] = 'User password match failed'
      redirect_to '/main/password'
      return
    end
    if params[:pass] != params[:c_pass]
      flash[:main_notice] = 'Two times input password is not consistent'
      redirect_to '/main/password'
      return
    end
    unless UserHelper.check_password_strong params[:pass]
      flash[:main_notice] = 'The password is not strong enough, please include one upper and lower case letter, one digit and one special character'
      redirect_to '/main/password'
      return
    end
    user = UserLogInfo.new
    user.uid = params[:uid]
    user.password = params[:pass]
    flash[:l_notice] = 'Update Password Successfully, please login again'
    UserHelper.update_user_log_info user
    redirect_to '/user/logout'
  end

  # get /user/:uid/group
  def get_user_groups
    uid = params[:uid]
    groups = GroupHelper.get_user_groups uid
    render json: { success: true, msg: nil, groups: groups.to_json }
  end
end
