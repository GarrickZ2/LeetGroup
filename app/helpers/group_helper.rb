module GroupHelper

  def self.create_group(uid, name, description, status = GroupInfo.group_status[:private])
    group = GroupInfo.create(name: name, description: description, create_time: Time.now, status: status)
    return false if group.nil?

    user = GroupToUser.create(gid: group.gid, uid: uid, role: GroupToUser.role_status[:owner])
    if user.nil?
      GroupInfo.delete(gid: group.gid)
      return false
    end
    group.gid
    true
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
    return false if user.nil? || user.role != GroupToUser.role_status[:owner] || user.role != GroupToUser.role_status[:manager]

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

  def self.add_user_to_group(gid, uid, role = GroupToUser.role_status[:owner])
    GroupToUser.create(gid: gid, uid: uid, role: role)
  end



end
