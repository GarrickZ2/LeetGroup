require 'rails_helper'

describe GroupHelper do
  describe 'User can create a group' do
    it 'user can create a group with name, desp and status' do
      gid = GroupHelper.create_group(1, 'LeetGroup', 'test')
      expect(gid != -1).eql? true
    end
  end

  describe 'User can destroy a group' do
    before(:each) do
      UserProfile.create(uid: 1)
      UserProfile.create(uid: 2)
      @gid = GroupHelper.create_group(1, 'LeetGroup', 'test').gid
    end
    it 'should delete the group if user is owner' do
      GroupHelper.delete_group @gid, 1
      expect(GroupInfo.exists?(@gid)).to eql false
    end
    it 'should not delete the group if not the owner' do
      GroupHelper.delete_group @gid, 2
      expect(GroupInfo.exists?(@gid)).to eql true
    end
  end

  describe 'User can update the group information' do
    before(:each) do
      UserProfile.create(uid: 1)
      UserProfile.create(uid: 2)
      @gid = GroupHelper.create_group(1, 'LeetGroup', 'test').gid
      @group_info = GroupInfo.new
      @group_info.gid = @gid
      @group_info.name = 'LG'
    end
    it 'should update the group if user is valid' do
      res = GroupHelper.update_group 1, @group_info
      expect(res).to eql true
      group_info = GroupInfo.find(@gid)
      expect(group_info.name).to eql @group_info.name
    end
    it 'should not update the group without permission' do
      res = GroupHelper.update_group 2, @group_info
      expect(res).to eql false
      group_info = GroupInfo.find @gid
      expect(group_info.name).not_to eql @group_info.name
    end
  end

  describe 'User can get the information of group' do
    it 'get the information of one group' do
      @gid = GroupHelper.create_group(1, 'LeetGroup', 'test').gid
      info = GroupHelper.get_group_info @gid
      expect(info.name).eql? 'LeetGroup'
      expect(info.description).eql? 'test'
    end
  end

  describe 'Generate the invite code' do
    before(:each) do
      @uid1 = UserHelper.create_account 'Garrick', '1', '!Zzx135246'
      @uid2 = UserHelper.create_account 'Alinda', '2', '!Zzx135246'
      @gid = GroupHelper.create_group(@uid1, 'LeetGroup', 'test').gid
    end
    it 'should generate a private invite code' do
      code = GroupHelper.generate_private_invite_code @gid, 'Alinda', nil
      expect(code.length).to eql 6
      res = GroupWelcomeCode.find code
      expect(res).not_to eql nil
    end
    it 'should not generate a private code if the user does not exist' do
      code = GroupHelper.generate_private_invite_code @gid, 'Viper', nil
      expect(code).to eql nil
    end
    it 'should generate a public code with an expiration date' do
      code = GroupHelper.generate_public_invite_code @gid, Time.now + 7.days
      expect(code.length).to eql 6
    end
  end

  describe 'User Join a group' do
    before(:each) do
      @uid1 = UserHelper.create_account 'Garrick', '1', '!Zzx135246'
      @uid2 = UserHelper.create_account 'Alinda', '2', '!Zzx135246'
      @gid = GroupHelper.create_group(@uid1, 'LeetGroup', 'test').gid
    end
    it 'User can join a group with a valid code' do
      code = GroupHelper.generate_public_invite_code @gid, Time.now + 7.days
      res = GroupHelper.join_group @uid2, code
      expect(res).to eql 1
      expect(GroupToUser.exists?(gid: @gid, uid: @uid2)).to eql true
    end
    it 'User cannot join with an invalid code' do
      res = GroupHelper.join_group @uid2, '12345'
      expect(res).to eql(-1)
      expect(GroupToUser.exists?(gid: @gid, uid: @uid2)).to eql false
    end
    it 'User cannot join with not invited private code' do
      code = GroupHelper.generate_private_invite_code @gid, 'Alinda', Time.now + 1.days
      res = GroupHelper.join_group 0, code
      expect(res).to eql(-2)
      expect(GroupToUser.exists?(gid: @gid, uid: @uid2)).to eql false
    end
    it 'User cannot join with an expired code' do
      code = GroupHelper.generate_private_invite_code @gid, 'Alinda', Time.now - 1.days
      res = GroupHelper.join_group @uid2, code
      expect(res).to eql(-3)
      expect(GroupToUser.exists?(gid: @gid, uid: @uid2)).to eql false
    end
  end
  describe 'Assign role to user' do
    before(:each) do
      UserProfile.create(uid: 1)
      UserProfile.create(uid: 2)
      UserProfile.create(uid: 3)
      @gid = GroupHelper.create_group(1, 'LeetGroup', 'test').gid
      GroupToUser.create(gid: @gid, uid: 2, role: GroupToUser.role_status[:member])
      GroupToUser.create(gid: @gid, uid: 3, role: GroupToUser.role_status[:member])
    end
    it 'should assign a role to user if valid' do
      res = GroupHelper.assign_role_to_user @gid, 1, 2, GroupToUser.role_status[:manager]
      expect(res).to eql 1
    end
    it 'should not assign a role if group does not exist' do
      res = GroupHelper.assign_role_to_user @gid + 1, 1, 2, GroupToUser.role_status[:manager]
      expect(res).to eql(-1)
    end
    it 'should not assign a role if the user does not in the group' do
      res = GroupHelper.assign_role_to_user @gid, 4, 2, GroupToUser.role_status[:manager]
      expect(res).to eql(-2)
      res = GroupHelper.assign_role_to_user @gid, 1, 4, GroupToUser.role_status[:manager]
      expect(res).to eql(-4)
    end
    it 'should not assign role if not owner' do
      res = GroupHelper.assign_role_to_user @gid, 3, 2, GroupToUser.role_status[:manager]
      expect(res).to eql(-3)
    end
    it 'should can only transfer the ownership of a group' do
      res = GroupHelper.assign_role_to_user @gid, 1, 2, GroupToUser.role_status[:owner]
      expect(res).to eql(1)
      user = GroupToUser.find_by(gid: @gid, uid: 1)
      expect(user.role).to eql GroupToUser.role_status[:member]
    end
  end

  describe 'Remove user from group' do
    before(:each) do
      UserProfile.create(uid: 1)
      UserProfile.create(uid: 2)
      UserProfile.create(uid: 3)
      @gid = GroupHelper.create_group(1, 'LeetGroup', 'test').gid
      GroupToUser.create(gid: @gid, uid: 2, role: GroupToUser.role_status[:member])
      GroupToUser.create(gid: @gid, uid: 3, role: GroupToUser.role_status[:member])
    end
    it 'should leave the group if valid' do
      expect(GroupToUser.find_by(gid: @gid, uid: 2)).not_to eql nil
      expect(GroupToUser.find_by(gid: @gid, uid: 3)).not_to eql nil
      res = GroupHelper.remove_user_from_group @gid, 2, 2
      expect(res).to eql 1
      res = GroupHelper.remove_user_from_group @gid, 1, 3
      expect(res).to eql 1
      expect(GroupToUser.find_by(gid: @gid, uid: 2)).to eql nil
      expect(GroupToUser.find_by(gid: @gid, uid: 3)).to eql nil
    end
    it 'should not leave the group if does not exist' do
      res = GroupHelper.remove_user_from_group @gid + 1, 2, 2
      expect(res).to eql(-1)
    end
    it 'should not leave the group if not have permission' do
      res = GroupHelper.remove_user_from_group @gid, 2, 1
      expect(res).to eql(-3)
    end
    it 'should not leave the group if user does not exist' do
      res = GroupHelper.remove_user_from_group @gid, 4, 2
      expect(res).to eql(-2)
      res = GroupHelper.remove_user_from_group @gid, 1, 4
      expect(res).to eql(-4)
    end
  end

  describe 'Get users in a group' do
    before(:each) do
      UserProfile.create(uid: 1)
      UserProfile.create(uid: 2)
      UserProfile.create(uid: 3)
      @gid = GroupHelper.create_group(1, 'LeetGroup', 'test').gid
      GroupToUser.create(gid: @gid, uid: 2, role: GroupToUser.role_status[:member])
      GroupToUser.create(gid: @gid, uid: 3, role: GroupToUser.role_status[:member])
    end
    it 'should get all users in a group' do
      res = GroupHelper.get_group_users @gid
      expect(res.result.length).to eql 3
    end
    it 'should not get result if does not exist' do
      res = GroupHelper.get_group_users @gid + 1
      expect(res.result).to eql nil
    end
  end

  describe 'User get all the groups involved' do
    it 'should get all the groups it participated' do
      GroupInfo.create(gid: 1)
      GroupInfo.create(gid: 2)
      GroupToUser.create(gid: 1, uid: 2, role: GroupToUser.role_status[:member])
      GroupToUser.create(gid: 2, uid: 2, role: GroupToUser.role_status[:member])
      GroupToUser.create(gid: 3, uid: 2, role: GroupToUser.role_status[:member])
      res = GroupHelper.get_user_groups 2
      expect(res.length).to eql 2
    end
  end
end