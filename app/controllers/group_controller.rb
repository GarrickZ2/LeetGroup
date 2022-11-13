class GroupController < ApplicationController
  # get /group/:gid
  def get_group_info
    gid = params[:gid]
    group = GroupHelper.get_group_info gid
    if group.nil?
      render json: { success: false, msg: 'Cannot find this group information' }
      return
    end
    render json: { success: true, msg: nil, data: group.to_json }
  end

  # post /group/new
  # Input: uid, name, description, status
  def create_group
    uid = params[:uid]
    name = params[:name]
    description = params[:description]
    status = params[:status]
    status = 0 if status.nil?
    group = GroupHelper.create_group uid, name, description, status
    message = if group.nil?
                'Create Group Failed, Please try again later'
              else
                "Create Group #{group.name} successfully!"
              end
    # render to the group page
    session[:groups] = GroupHelper.get_user_groups uid unless group.nil?
    render json: { success: !group.nil?, msg: message }
  end

  # get /group/:gid/destroy
  # Input: uid
  def destroy_group
    uid = params[:uid]
    gid = params[:gid]

    res = GroupHelper.delete_group gid, uid
    flash[:main_notice] = if res
                            'Delete Group Successfully'
                          else
                            'Delete Failed, the user does not have the permission'
                          end
    redirect_to main_dashboard_path
  end

  # post /group/:gid/update
  # Input: uid, gid, name, description, status
  def update_group
    group_info = GroupInfo.new
    group_info.gid = params[:gid]
    group_info.name = params[:name]
    group_info.description = params[:description]
    group_info.status = params[:status]
    uid = params[:uid]

    res = GroupHelper.update_group uid, group_info
    flash[:main_notice] =
      if res
        'Update Successfully'
      else
        'Update Failed because of lack permission'
      end
    # render to the group detail page
  end

  # get /group/:gid/invite
  # input: uid, date
  def generate_invite_code
    gid = params[:gid]
    username = params[:username]
    date = params[:date]
    type = params[:status].to_i
    expiration_date =
      case date
      when '7'
        Time.now + 7.days
      when '30'
        Time.now + 30.days
      end
    code =
      if type.zero?
        GroupHelper.generate_private_invite_code gid, username, expiration_date
      else
        GroupHelper.generate_public_invite_code gid, expiration_date
      end
    if code.nil?
      render json: { success: false, msg: 'The user does not exist' }
      return
    end

    url = "#{request.base_url}/group/join/#{code}"
    render json: { success: true, msg: nil, code: code, url: url }
  end

  # get /group/join/:code
  # input: uid
  def join_group
    uid = params[:uid]
    uid = session[:uid] if uid.nil?
    if uid.nil?
      flash[:l_notice] = 'Please login firstly to join a group'
      redirect_to user_index_path type: 'login'
      return
    end
    res = GroupHelper.join_group uid, params[:code]
    message =
      case res
      when -1
        'The code does not exist'
      when -2
        'The code is private, can not use it'
      when -3
        'The code has been expired'
      when -4
        'You have already joined this group'
      else
        'Join the group successfully'
      end
    p uid
    session[:groups] = GroupHelper.get_user_groups uid if res.positive?

    if params[:uid].nil?
      flash[:main_notice] = message
      redirect_to main_dashboard_path
      return
    end

    render json: { success: res.positive?, msg: message }
  end

  # get /group/:gid/remove_user
  def user_remove
    gid = params[:gid]
    operator = params[:operator]
    uid = params[:uid]

    res = GroupHelper.remove_user_from_group gid, operator, uid
    message =
      case res
      when 1
        'Remove the user successfully'
      when -1
        'The group does not exist'
      when -2
        'The operator does not exist'
      when -3
        'The operator does not have the permission'
      when -4
        'The target user does not exist'
      end
    render json: { success: res.positive?, msg: message }
  end

  # post /group/:gid/update_role
  def change_user_role
    uid = params[:uid]
    gid = params[:gid]
    operator = params[:operator]
    role = params[:role].to_i
    res = GroupHelper.assign_role_to_user gid, operator, uid, role
    message =
      case res
      when 1
        'Change Role Successfully'
      when -1
        'The group does not exist'
      when -2
        'The operator does not exist'
      when -3
        'The operator does not have the permission'
      when -4
        'The target user does not exist'
      end
    render json: { success: res.positive?, msg: message }
  end

  # get /group/:gid/users
  def get_group_users
    gid = params[:gid]
    size = params[:size]
    page = params[:page]
    users = GroupHelper.get_group_users gid, size, page
    render json: { success: true, msg: nil, users: users.to_json }
  end

end
