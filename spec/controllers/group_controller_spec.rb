require 'rails_helper'

describe GroupController do
  describe 'Remove a user from a group' do
    before(:each) do
      @uid1 = UserHelper.create_account 'Garrick', 'zzx135246@163.com', '!Zzx135246'
      @uid2 = UserHelper.create_account 'Alinda', 'alinda@163.com', '!Zzx135246'
      @group = GroupHelper.create_group @uid1, 'LeetGroup', ''
      GroupToUser.create(gid: @group.gid, uid: @uid2, role: GroupToUser.role_status[:member])
    end

    it 'User can leave the group' do
      expect(GroupToUser.find_by(gid: @group.gid, uid: @uid2).nil?).to eql false
      get :user_remove, params: {
        gid: @group.gid,
        uid: @uid2,
        operator: @uid2
      }
      expect(GroupToUser.find_by(gid: @group.gid, uid: @uid2).nil?).to eql true
    end

    it 'Can not remove in a un-existed group' do
      result = get :user_remove, params: {
        gid: @group.gid - 1,
        uid: @uid2,
        operator: @uid2
      }
      parsed_result = JSON.parse(result.body)
      expect(parsed_result['success']).to eql false
    end

    it 'Can not remove a un-existed member' do
      result = get :user_remove, params: {
        gid: @group.gid,
        uid: 0,
        operator: @uid1
      }
      parsed_result = JSON.parse(result.body)
      expect(parsed_result['success']).to eql false
    end

    it 'Can not remove by a un-existed user' do
      result = get :user_remove, params: {
        gid: @group.gid,
        uid: @uid2,
        operator: 0
      }
      parsed_result = JSON.parse(result.body)
      expect(parsed_result['success']).to eql false
    end

    it 'Can not remove without permission' do
      result = get :user_remove, params: {
        gid: @group.gid,
        uid: @uid1,
        operator: @uid2
      }
      parsed_result = JSON.parse(result.body)
      expect(parsed_result['success']).to eql false
    end
  end

  describe 'Change user group role' do
    before(:each) do
      @uid1 = UserHelper.create_account 'Garrick', 'zzx135246@163.com', '!Zzx135246'
      @uid2 = UserHelper.create_account 'Alinda', 'alinda@163.com', '!Zzx135246'
      @group = GroupHelper.create_group @uid1, 'LeetGroup', ''
      GroupToUser.create(gid: @group.gid, uid: @uid2, role: GroupToUser.role_status[:member])
    end
    it 'change user role to member or manager' do
      post :change_user_role, params: {
        uid: @uid2,
        gid: @group.gid,
        operator: @uid1,
        role: GroupToUser.role_status[:manager]
      }
      user = GroupToUser.find_by(gid: @group.gid, uid: @uid2)
      expect(user.role).to eql GroupToUser.role_status[:manager]
    end

    it 'cannot change group if does not exist' do
      result = post :change_user_role, params: {
        uid: @uid2,
        gid: @group.gid - 1,
        operator: @uid1,
        role: GroupToUser.role_status[:manager]
      }
      parsed_result = JSON.parse(result.body)
      expect(parsed_result['success']).to eql false
    end

    it 'cannot change if operator not exist' do
      result = post :change_user_role, params: {
        uid: @uid2,
        gid: @group.gid,
        operator: 0,
        role: GroupToUser.role_status[:manager]
      }
      parsed_result = JSON.parse(result.body)
      expect(parsed_result['success']).to eql false
    end

    it 'cannot change if target user not exist' do
      result = post :change_user_role, params: {
        uid: 0,
        gid: @group.gid,
        operator: @uid1,
        role: GroupToUser.role_status[:manager]
      }
      parsed_result = JSON.parse(result.body)
      expect(parsed_result['success']).to eql false
    end

    it 'cannot change if without permission' do
      result = post :change_user_role, params: {
        uid: @uid1,
        gid: @group.gid,
        operator: @uid2,
        role: GroupToUser.role_status[:manager]
      }
      parsed_result = JSON.parse(result.body)
      expect(parsed_result['success']).to eql false
    end
  end
end
