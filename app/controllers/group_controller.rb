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
    group = GroupHelper.create_group uid, name, description
    flash[:main_notice] = if group.nil?
                            # create failed, state some reason
                            'Create Group Failed, Please try again later'
                          else
                            "Create Group #{group.name} successfully!"
                          end
    # render to the group page
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
  # input: uid, expiration_date
  def generate_invite_code
    gid = params[:gid]
    uid = params[:uid]
    expiration_date = params[:expiration_date]
    type = params[:status]
    code =
      if type.zero?
        GroupHelper.generate_private_invite_code gid, uid, expiration_date
      else
        GroupHelper.generate_public_invite_code gid, expiration_date
      end
    if code.nil?
      render json: { success: false, msg: "The user does not exist" }
      return
    end

    url = "#{request.base_url}/group/join/#{code}"
    render json: { success: true, msg: nil, code: code, url: url }
  end

  # get /group/join/:code
  # input: uid
  def join_group
    res = GroupHelper.join_group params[:uid], params[:code]
    flash[:main_notice] =
      case res
      when 1
        'Join the group successfully'
      when -1
        'The code does not exist'
      when -2
        'The code is private, can not use it'
      when -3
        'The code has been expired'
      end
    # return to the main dashboard
    redirect_to main_dashboard_path
  end

  # get /group/:gid/remove_user
  def user_remove
    gid = params[:gid]
    operator = params[:operator]
    uid = params[:uid]

    res = GroupHelper.remove_user_from_group gid, operator, uid
    flash[:main_notice] =
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
    # render to the group info page
  end

  # post /group/:gid/update_role
  def change_user_role
    uid = params[:uid]
    gid = params[:gid]
    operator = params[:operator]
    role = params[:role]
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
    users = GroupHelper.get_group_users gid
    render json: { success: true, msg: nil, users: users.to_json }
  end

end
