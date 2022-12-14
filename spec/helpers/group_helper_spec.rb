require 'rails_helper'

describe GroupHelper do
  describe 'User can create a group' do
    it 'user can create a group with name, desp and status' do
      gid = GroupHelper.create_group(1, 'LeetGroup', 'test')
      expect(gid != -1).eql? true
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
    it 'User cannot join if already in the group' do
      GroupToUser.create(gid: @gid, uid: @uid2)
      code = GroupHelper.generate_private_invite_code @gid, 'Alinda', Time.now + 7.days
      res = GroupHelper.join_group @uid2, code
      expect(res).to eql(-4)
      expect(GroupToUser.exists?(gid: @gid, uid: @uid2)).to eql true
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
    it 'should delete user from group if the user does not exist' do
      UserProfile.delete_by(uid: 3)
      res = GroupHelper.get_group_users @gid
      expect(res.result.length).to eql 2
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

  describe 'User view card in group' do
    time1 = '2022-10-31T04:26:02.000Z'
    time2 = '2022-10-31T05:26:02.000Z'
    time3 = '2022-10-31T06:26:02.000Z'

    before(:each) do
      Card.create(cid: 1, uid: 1, title: 'Two Sum', source: 'LeetCode', description: 'easy', schedule_time: nil, status: 1,
                  stars: 1, used_time: 0, create_time: time1, update_time: time1)
      Card.create(cid: 2, uid: 1, title: 'Reverse Integer', source: 'LeetCode', description: 'medium', schedule_time: nil, status: 2,
                  stars: 0, used_time: 0, create_time: time2, update_time: time2)
      Card.create(cid: 3, uid: 2, title: 'Median of Two Sorted Arrays', source: 'LeetCode', description: 'hard', schedule_time: nil, status: 0,
                  stars: 2, used_time: 0, create_time: time3, update_time: time3)
      GroupToCard.create(gid: 1, cid: 1)
      GroupToCard.create(gid: 1, cid: 2)
      GroupToCard.create(gid: 1, cid: 3)
    end

    card_expect = {
      cid: 1,
      uid: 1,
      title: 'Two Sum',
      source: 'LeetCode',
      description: 'easy',
      status: 1,
      used_time: 0,
      stars: 1,
      create_time: time1,
      update_time: time1,
      schedule_time: nil
    }

    it 'should show card of all status by create_time in asc' do
      @card_view = GroupHelper.view_card(1, 3, 2, 0, 'create_time', 'asc')
      @cards = @card_view.card_info
      @page_info = @card_view.page_info
      page_info_expect = PageInfo.new(2, 3, 0, 2)
      expect(@page_info.to_json).to eq page_info_expect.to_json
      expect(@cards[0].to_json).to eq card_expect.to_json
    end

    it 'should show card of all status by create_time in desc' do
      @card_view = GroupHelper.view_card(1, 3, 1, 2, 'create_time', 'desc')
      @cards = @card_view.card_info
      @page_info = @card_view.page_info
      page_info_expect = PageInfo.new(3, 3, 2, 1)
      expect(@page_info.to_json).to eq page_info_expect.to_json
      expect(@cards[0].to_json).to eq card_expect.to_json
    end

    it 'should show card of status 1' do
      @card_view = GroupHelper.view_card(1, 1, 1, 0, nil, nil)
      @cards = @card_view.card_info
      @page_info = @card_view.page_info
      page_info_expect = PageInfo.new(1, 1, 0, 1)
      expect(@page_info.to_json).to eq page_info_expect.to_json
      expect(@cards[0].to_json).to eq card_expect.to_json
    end

    it 'should get nothing if there is no card in the group' do
      @card_view = GroupHelper.view_card(2, 3, 2, 0, nil, nil)
      @cards = @card_view.card_info
      @page_info = @card_view.page_info
      page_info_expect = PageInfo.new(0, 0, 0, 0)
      expect(@page_info.to_json).to eq page_info_expect.to_json
      expect(@cards.count).to eq 0
    end
  end

  describe 'view card detail in group' do
    it 'should successfully get the card detail' do
      @card = Card.create(uid: 23, cid: 22, title: '000', source: '123', description: '321')
      card = GroupHelper.view_card_detail(1, 22)
      expect(card).to eq @card
    end
  end

  describe 'check user permission of the card' do
    before(:each) do
      Card.create(uid: 3, cid: 22, title: '000', source: '123', description: '321')
      GroupToUser.create(gid: 1, uid: 1, role: GroupToUser.role_status[:owner])
      GroupToUser.create(gid: 1, uid: 2, role: GroupToUser.role_status[:member])
      GroupToUser.create(gid: 1, uid: 3, role: GroupToUser.role_status[:member])
    end

    it 'should return 1 if user is the owner of the group ' do
      permission = GroupHelper.check_permission(1, 1, 22)
      expect(permission).to eq 1
    end

    it 'should return 1 if user is the owner of the card ' do
      permission = GroupHelper.check_permission(1, 3, 22)
      expect(permission).to eq 1
    end

    it 'should return -1 if user is not the owner of the group or the card' do
      permission = GroupHelper.check_permission(1, 2, 22)
      expect(permission).to eq -1
    end
  end

  describe 'delete card from group' do
    before(:each) do
      GroupToCard.create(gid: 1, cid: 1)
    end

    it 'should successfully delete if the card exists in group' do
      res = GroupHelper.delete_card(1, 1)
      expect res
    end

    it 'should fail to delete if the card does not exist in group' do
      res = GroupHelper.delete_card(1, 2)
      expect !res
    end
  end

  describe 'get total users number' do
    before(:each) do
      GroupToUser.create(gid: 1, uid: 1, role: GroupToUser.role_status[:owner])
      GroupToUser.create(gid: 1, uid: 2, role: GroupToUser.role_status[:member])
      GroupToUser.create(gid: 1, uid: 3, role: GroupToUser.role_status[:member])
    end

    it 'should return total users number in this group' do
      res = GroupHelper.get_total_users_number(1)
      expect(res).to eq 3
    end
  end

  describe 'get total cards number' do
    before(:each) do
      GroupToCard.create(gid: 1, cid: 1)
      GroupToCard.create(gid: 1, cid: 2)
      GroupToCard.create(gid: 1, cid: 3)
    end

    it 'should return total cards number in this group' do
      res = GroupHelper.get_total_cards_number(1)
      expect(res).to eq 3
    end
  end

  describe 'get group owner info' do
    before(:each) do
      GroupToUser.create(gid: 1, uid: 1, role: GroupToUser.role_status[:owner])
      UserProfile.create(uid: 1, username: 'Maggie', avatar: '/avatar/1.jpg')
    end

    it 'should return total cards number in this group' do
      res = GroupHelper.get_group_owner_info(1)
      expect(res.uid).to eq 1
      expect(res.username).to eq 'Maggie'
      expect(res.avatar).to eq '/avatar/1.jpg'
    end
  end

  describe 'Get Group Detail Information' do
    before(:each) do
      @group = GroupInfo.create(gid: 1)
      GroupToUser.create(gid: 1, uid: 1, role: GroupToUser.role_status[:owner])
      UserProfile.create(uid: 1, username: 'Maggie', avatar: '/avatar/1.jpg')
    end
    it 'should find the owner and member information' do
      result = GroupHelper.get_group_detail @group
      expect(result.user.uid).to eql 1
      expect(result.user.username).to eql 'Maggie'
      expect(result.count).to eql 1
    end
  end
end
