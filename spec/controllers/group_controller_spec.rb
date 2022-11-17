require 'rails_helper'

describe GroupController do
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
end