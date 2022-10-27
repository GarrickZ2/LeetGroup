class UserController < ApplicationController
  def index
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
    uid = UserLogInfo.create_user params[:username], params[:email], params[:password]
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
    redirect_to main_dashboard_path
  end
end
