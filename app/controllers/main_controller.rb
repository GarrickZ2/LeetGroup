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
  def password; end

  def group
    @gid = params[:gid]
    uid = session[:uid]
    if GroupToUser.find_by(gid: @gid, uid: uid).nil?
      flash[:main_notice] = 'You haven\'t join this group'
      session[:groups] = GroupHelper.get_user_groups uid
      redirect_to main_dashboard_path
      return
    end

    @group_info = GroupHelper.get_group_info @gid
    member_result = GroupHelper.get_group_users @gid
    @members = member_result.result
    flash[:tab] = params[:tab] unless params[:tab].nil?
  end
end
