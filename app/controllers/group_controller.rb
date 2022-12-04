class GroupController < ApplicationController
  # post /group/new
  # Input: uid, name, description, status
  def create_group
    uid = params[:uid]
    name = params[:name]
    description = params[:description]
    status = params[:status]
    status = if status.nil?
               GroupInfo.group_status[:private]
             else
               status[0].to_i
             end
    group = GroupHelper.create_group uid, name, description, status
    message = if group.nil?
                'Create Group Failed, Please try again later'
              else
                "Create Group #{group.name} successfully!"
              end
    # render to the group page
    session[:groups] = GroupHelper.get_user_groups uid
    render json: { success: !group.nil?, msg: message }
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
    uid = uid.to_i if uid.is_a? String
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
    session[:groups] = GroupHelper.get_user_groups uid if res.positive?

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

  # post /group/:gid/cards
  def view_group_cards
    card_view = GroupHelper.view_card params[:gid], params[:status].to_i, params[:page_size].to_i, params[:offset].to_i, params[:sort_by],
                                      params[:sort_type]

    page_info = card_view.page_info.to_json
    card_info = card_view.card_info
    cards = []
    card_info.each { |card|
      cards.append(card.to_json)
    }
    render json: { card_info: cards, page_info: page_info }
  end

  # get /group/:gid/card_detail/:cid
  def view_group_card_detail
    res = GroupHelper.view_card_detail params[:gid], params[:cid]
    render json: { card: res }
  end

  # get 'group/:gid/check_permission/:uid/:cid' => 'group#check_permission'
  # only group owner or card owner can delete the card
  def check_permission
    res = GroupHelper.check_permission params[:gid], params[:uid], params[:cid]
    render json: { result: res }
  end

  # get 'group/card/delete' => 'group#delete_card'
  # delete certain card from group
  def delete_card
    res = GroupHelper.delete_card params[:gid], params[:cid]
    unless res
      render json: { success: false, msg: "The card doesn't exist" }
      return
    end
    render json: { success: true, msg: 'The card deleted successfully' }
  end

  def group_overview
    total_users = GroupHelper.get_total_users_number params[:gid]
    total_cards = GroupHelper.get_total_cards_number params[:gid]
    owner_info = GroupHelper.get_group_owner_info params[:gid]
    group_info = GroupHelper.get_group_info params[:gid]
    create_time = group_info.create_time
    render json: { total_users: total_users, total_cards: total_cards, owner_info: owner_info, create_time: create_time }
  end
end
