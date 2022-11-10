# require 'instances/user_view'
module GroupHelper
  def self.create_group(uid, name, description, status = GroupInfo.group_status[:private])
    group = GroupInfo.create(name: name, description: description, create_time: Time.now, status: status)
    return -1 if group.nil?

    GroupToUser.create(gid: group.gid, uid: uid, role: GroupToUser.role_status[:owner])
    group.gid
  end

  def self.delete_group(gid, uid)
    user = GroupToUser.find_by(gid: gid, uid: uid)
    return false if user.nil? || user.role != GroupToUser.role_status[:owner]

    # delete all the members firstly
    GroupToUser.delete_by(gid: gid)
    # delete all the cards secondly
    GroupToCard.delete_by(gid: gid)
    # delete the group info
    GroupInfo.delete_by(gid: gid)
    true
  end

  def self.update_group(uid, group_info)
    return false if group_info.gid.nil?

    user = GroupToUser.find_by(gid: group_info.gid, uid: uid)
    if user.nil? || (user.role != GroupToUser.role_status[:owner] && user.role != GroupToUser.role_status[:manager])
      return false
    end

    group = GroupInfo.find_by(gid: group_info.gid)
    return false if group.nil?

    GroupInfo.columns.each do |c|
      type = c.name
      next if type == 'gid'

      val = group_info.method(type).call
      group.method("#{type}=").call val unless val.nil?
    end
    group.save
    true
  end

  def self.get_group_info(gid)
    GroupInfo.find_by(gid: gid)
  end

  def self.generate_private_invite_code(gid, uid, expiration_date = nil)
    unless UserProfile.exists? uid
      return nil
    end

    code = CodeGenerator.generate
    welcome_code = GroupWelcomeCode.create(code: code, gid: gid, uid: uid, status: GroupWelcomeCode.welcome_type[:private], expiration_date: expiration_date )
    while welcome_code.nil?
      code = CodeGenerator.generate
      welcome_code = GroupWelcomeCode.create(code: code, gid: gid, uid: uid, status: GroupWelcomeCode.welcome_type[:private], expiration_date: expiration_date )
    end
    code
  end

  def self.generate_public_invite_code(gid, expiration_date)
    code = CodeGenerator.generate
    welcome_code = GroupWelcomeCode.create(code: code, gid: gid, expiration_date: expiration_date, status: GroupWelcomeCode.welcome_type[:public])
    while welcome_code.nil?
      code = CodeGenerator.generate
      welcome_code = GroupWelcomeCode.create(code: code, gid: gid, expiration_date: expiration_date, status: GroupWelcomeCode.welcome_type[:public])
    end
    code
  end

  def self.join_group(uid, code)
    # valid the code
    welcome = GroupWelcomeCode.find_by(code: code)
    if welcome.nil?
      return -1 # doesn't have such welcome code
    end

    delete_code = false
    if welcome.status == GroupWelcomeCode.welcome_type[:private] # private
      if welcome.uid != uid
        return -2 # didn't invite to such user
      end

      delete_code = true
    end
    if Time.now.to_i > welcome.expiration_date.to_time.to_i # has been expired
      GroupWelcomeCode.delete_by(code: code)
      return -3 # the welcome has expired
    end
    GroupToUser.create(gid: welcome.gid, uid: uid, role: GroupToUser.role_status[:member])
    GroupWelcomeCode.delete_by(code: code) if delete_code
    1 # success
  end

  def self.remove_user_from_group(gid, operator, uid)
    unless GroupInfo.exists? gid
      return -1 # group doesn't exist
    end

    permission_role = GroupToUser.find_by(gid: gid, uid: operator)
    if permission_role.nil?
      return -2 # operator doesn't exist
    end

    if operator == uid # leave the group
      GroupToUser.delete_by(gid: gid, uid: uid)
      return 1 # successfully leave the group
    end
    if GroupToUser.find_by(gid: gid, uid: uid).nil?
      return -4 # doesn't have target user
    end

    if permission_role.role != GroupToUser.role_status[:owner] && permission_role.role != GroupToUser.role_status[:manager]
      return -3 # no permission to do
    end

    GroupToUser.delete_by(gid: gid, uid: uid)
    1 # remove successfully
  end

  def self.assign_role_to_user(gid, operator, uid, role)
    unless GroupInfo.exists? gid
      return -1 # group doesn't exist
    end

    permission_role = GroupToUser.find_by(gid: gid, uid: operator)
    if permission_role.nil?
      return -2 # doesn't have this person
    end

    if permission_role.role != GroupToUser.role_status[:owner]
      return -3 # doesn't have right to do this
    end

    target_user = GroupToUser.find_by(gid: gid, uid: uid)
    if target_user.nil?
      return -4 # doesn't have target user
    end

    if role == GroupToUser.role_status[:owner] # transfer the ownership
      permission_role.role = GroupToUser.role_status[:manager]
      permission_role.save
    end
    target_user.role = role
    target_user.save
    1 # success
  end

  def self.get_group_users(gid, size = nil, page = nil)
    unless GroupInfo.exists? gid
      return UserResult.new nil, nil # group doesn't exist
    end

    total_num = GroupToUser.where(gid: gid).count
    page = 1 if page.nil?
    size = total_num if size.nil?
    uids = GroupToUser.where(gid: gid).offset(size * (page - 1)).limit(size)
    current_num = uids.count
    result = []
    uids.each do |u|
      user = UserProfile.find_by(uid: u.uid)
      if user.nil?
        GroupToUser.delete_by(gid: gid, uid: u.uid)
      else
        result.append(UserView.new(user, u.role))
      end
    end
    page_info = PageInfo.new((total_num.to_f / size).ceil, total_num, page, current_num)
    UserResult.new result, page_info
  end

  def self.get_user_groups(uid)
    groups = GroupToUser.where(uid: uid)
    result = []
    groups.each do |g|
      group = GroupInfo.find_by(gid: g.gid)
      next if group.nil?

      result.append group
    end
    result
  end
end
