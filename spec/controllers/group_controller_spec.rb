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
  # one scenario
  describe 'create group' do
    it 'should successfully create the group' do
      post :create_group, params: {
        uid: 1,
        name: 'test-group-1',
        description: 'the first test group',
        status: 0
      }
      success = JSON.parse(response.body)['success']
      msg = JSON.parse(response.body)['msg']
      expect(success).to eq true
      expect(msg).to eq "Create Group test-group-1 successfully!"
    end

    it 'should not create group with invalid status' do
      post :create_group, params: {
        uid: 1,
        name: 'test-group-1',
        description: 'the first test group',
        status: 5
      }
      success = JSON.parse(response.body)['success']
      msg = JSON.parse(response.body)['msg']
      expect(success).to eq false
      expect(msg).to eq "Create Group Failed, Please try again later"
    end
  end

  describe 'generate invite code' do
    before(:all) do
      UserLogInfo.create(username: 'abcd123456E', email: 'zzzz@bbb.com', password: 'asdvoJF1982!@')
      @params = {
        gid: 1,
        username: 'abcd123456E',
        date: '7',
        status: 0
      }
    end

    it 'should generate private code of 7 days' do
      post :generate_invite_code, params: @params
      success = JSON.parse(response.body)['success']
      msg = JSON.parse(response.body)['msg']
      expect(success).to eq true
      expect(msg).to eq nil
    end

    it 'should generate private code of 30 days' do
      @params['date'] = '30'
      post :generate_invite_code, params: @params
      success = JSON.parse(response.body)['success']
      msg = JSON.parse(response.body)['msg']
      expect(success).to eq true
      expect(msg).to eq nil
    end

    it 'should generate public code of 7 days' do
      @params['status'] = 1
      post :generate_invite_code, params: @params
      success = JSON.parse(response.body)['success']
      msg = JSON.parse(response.body)['msg']
      expect(success).to eq true
      expect(msg).to eq nil
    end

    it 'should NOT generate code with wrong info' do
      @params['status'] = 0
      @params['username'] = 'test'
      post :generate_invite_code, params: @params
      success = JSON.parse(response.body)['success']
      msg = JSON.parse(response.body)['msg']
      expect(success).to eq false
      expect(msg).to eq 'The user does not exist'
    end
  end

  describe 'join group' do
    before(:each) do
      session[:uid] = nil
    end
    it 'redirect to login page when no uid is passed' do
      get :join_group, params: {
        code: 'test'
      }
      expect(response).to redirect_to '/user/index/login'
    end

    it 'failed when the code does not exist' do
      get :join_group, params: {
        uid: 1,
        code: 'test'
      }
      msg = JSON.parse(response.body)['msg']
      expect(msg).to eq 'The code does not exist'
    end

    it 'failed when the code is private' do
      GroupWelcomeCode.create(code: 'test', gid: 1, uid: 1, status: GroupWelcomeCode.welcome_type[:private], expiration_date: Time.now + 1.days)
      get :join_group, params: {
        uid: 2,
        code: 'test'
      }
      msg = JSON.parse(response.body)['msg']
      expect(msg).to eq 'The code is private, can not use it'
    end

    it 'failed when the code is expired' do
      GroupWelcomeCode.create(code: 'test', gid: 1, uid: 1, status: GroupWelcomeCode.welcome_type[:private], expiration_date: Time.now - 1.days)
      get :join_group, params: {
        uid: 1,
        code: 'test'
      }
      msg = JSON.parse(response.body)['msg']
      expect(msg).to eq 'The code has been expired'
    end

    it 'failed when the code is expired' do
      GroupWelcomeCode.create(code: 'test', gid: 1, uid: 1, status: GroupWelcomeCode.welcome_type[:private], expiration_date: Time.now + 1.days)
      GroupToUser.create(gid: 1, uid: 1)
      get :join_group, params: {
        uid: 1,
        code: 'test'
      }
      msg = JSON.parse(response.body)['msg']
      expect(msg).to eq 'You have already joined this group'
    end

    it 'successfully join the group' do
      GroupWelcomeCode.create(code: 'test', gid: 1, uid: 1, status: GroupWelcomeCode.welcome_type[:private], expiration_date: Time.now + 1.days)
      get :join_group, params: {
        uid: 1,
        code: 'test'
      }
      msg = JSON.parse(response.body)['msg']
      expect(msg).to eq 'Join the group successfully'
    end
  end

  describe 'view group cards' do
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

    it 'should view cards of all status sorted by create_time in asc' do
      get :view_group_cards, params: {
        gid: 1,
        status: 3,
        page_size: 2,
        offset: 0,
        sort_by: 'create_time',
        sort_type: 'asc'
      }

      page_info_expect = {
        total_page: 2,
        total_size: 3,
        current_page: 0,
        current_size: 2
      }
      card_info = JSON.parse(response.body)['card_info']
      page_info = JSON.parse(response.body)['page_info']
      card = JSON.parse(card_info[0])
      expect(card_info.count).to eq 2
      expect(card.to_json).to eq card_expect.to_json
      expect(page_info).to eq page_info_expect.to_json
    end

    it 'should view cards of all status sorted by create_time in desc' do
      get :view_group_cards, params: {
        gid: 1,
        status: 3,
        page_size: 1,
        offset: 2,
        sort_by: 'create_time',
        sort_type: 'desc'
      }

      page_info_expect = {
        total_page: 3,
        total_size: 3,
        current_page: 2,
        current_size: 1
      }
      card_info = JSON.parse(response.body)['card_info']
      page_info = JSON.parse(response.body)['page_info']
      card = JSON.parse(card_info[0])
      expect(card_info.count).to eq 1
      expect(card.to_json).to eq card_expect.to_json
      expect(page_info).to eq page_info_expect.to_json
    end

    it 'should view cards of status 1' do
      get :view_group_cards, params: {
        gid: 1,
        status: 1,
        page_size: 1,
        offset: 0,
        sort_by: nil,
        sort_type: nil
      }

      page_info_expect = {
        total_page: 1,
        total_size: 1,
        current_page: 0,
        current_size: 1
      }
      card_info = JSON.parse(response.body)['card_info']
      page_info = JSON.parse(response.body)['page_info']
      card = JSON.parse(card_info[0])
      expect(card_info.count).to eq 1
      expect(card.to_json).to eq card_expect.to_json
      expect(page_info).to eq page_info_expect.to_json
    end

    it 'should get nothing if there is no card in the group' do
      get :view_group_cards, params: {
        gid: 2,
        status: 3,
        page_size: 2,
        offset: 0,
        sort_by: nil,
        sort_type: nil
      }

      page_info_expect = {
        total_page: 0,
        total_size: 0,
        current_page: 0,
        current_size: 0
      }
      card_info = JSON.parse(response.body)['card_info']
      page_info = JSON.parse(response.body)['page_info']
      expect(card_info.count).to eq 0
      expect(page_info).to eq page_info_expect.to_json
    end
  end

  describe 'view group card detail' do
    before(:each) do
      @card = Card.create(uid: 23, cid: 22, title: '000', source: '123', description: '321')
    end

    it 'should successfully get the card detail' do
      get :view_group_card_detail, params: {
        gid: 1,
        cid: 22
      }
      card = JSON.parse(response.body)['card']
      expect(card.to_json).to eq @card.to_json
    end
  end

  describe 'check permission' do
    before(:each) do
      Card.create(uid: 3, cid: 22, title: '000', source: '123', description: '321')
      GroupToUser.create(gid: 1, uid: 1, role: GroupToUser.role_status[:owner])
      GroupToUser.create(gid: 1, uid: 2, role: GroupToUser.role_status[:member])
      GroupToUser.create(gid: 1, uid: 3, role: GroupToUser.role_status[:member])
    end

    it 'should return 1 if user is the owner of the group ' do
      get :check_permission, params: {
        gid: 1,
        uid: 1,
        cid: 22
      }
      result = JSON.parse(response.body)['result']
      expect(result).to eq 1
    end

    it 'should return 1 if user is the owner of the card ' do
      get :check_permission, params: {
        gid: 1,
        uid: 3,
        cid: 22
      }
      result = JSON.parse(response.body)['result']
      expect(result).to eq 1
    end

    it 'should return -1 if user is not the owner of the group or the card' do
      get :check_permission, params: {
        gid: 1,
        uid: 2,
        cid: 22
      }
      result = JSON.parse(response.body)['result']
      expect(result).to eq -1
    end
  end

  describe 'delete card' do
    before(:each) do
      GroupToCard.create(gid: 1, cid: 1)
    end

    it 'should get success msg if delete successfully' do
      post :delete_card, params: {
        gid: 1,
        cid: 1
      }
      success = JSON.parse(response.body)['success']
      msg = JSON.parse(response.body)['msg']
      expect(success).to eq true
      expect(msg).to eq 'The card deleted successfully'
    end

    it 'should get failure msg if delete failed' do
      post :delete_card, params: {
        gid: 1,
        cid: 2
      }
      success = JSON.parse(response.body)['success']
      msg = JSON.parse(response.body)['msg']
      expect(success).to eq false
      expect(msg).to eq "The card doesn't exist"
    end


  end
end
