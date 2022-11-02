require 'rails_helper'

describe UserController do
  describe 'user login or signup' do
    it 'user goto the register page' do
      # get :user_index_path, :type => 'register'
      get :index, params: { type: 'register' }
      expect(response).to render_template('user/index')
    end
    it 'user goto the register page' do
      # get :user_index_path, :type => 'register'
      get :index, params: { type: 'login' }
      expect(response).to render_template('user/index')
    end
    it 'user goto the main page if login already' do
      session[:uid] = 2
      get :index, params: { type: 'login' }
      expect(response).to redirect_to('/main/dashboard')
    end
  end

  describe 'user register account' do
    user = {}
    before(:each) do
      user['username'] = 'GarrickZ'
      user['email'] = 'zzx135246@gmail.com'
      user['password'] = '!Zzx135246'
    end
    it 'user success register an account' do
      get :create, params: user
      expect(response).to redirect_to '/main/dashboard'
    end

    it 'user input a weak password' do
      user['password'] = '123'
      get :create, params: user
      expect(response).to redirect_to '/user/index/register'
      expect(flash[:r_notice]).to include 'Password'
    end

    it 'user input a wrong type username' do
      user['username'] = '!Zzx123456'
      get :create, params: user
      expect(response).to redirect_to '/user/index/register'
      expect(flash[:r_notice]).to include 'Username'
    end

    it 'user input a wrong email' do
      user['email'] = '123@!123'
      get :create, params: user
      expect(response).to redirect_to '/user/index/register'
      expect(flash[:r_notice]).to include 'Email'
    end

    it 'user create failed with a same username' do
      get :create, params: user
      user['email'] = '123@123.com'
      get :create, params: user
      expect(response).to redirect_to '/user/index/register'
      expect(flash[:r_notice]).to include 'Username has been taken'
    end

    it 'user create failed with a same email' do
      get :create, params: user
      user['username'] = 'ZZX123456'
      get :create, params: user
      expect(response).to redirect_to '/user/index/register'
      expect(flash[:r_notice]).to include 'Email is in used'
    end

  end

  describe 'user login account' do
    before(:each) do
      # insert a registered user
      UserHelper.create_account 'Garrick', '123@123.com', '!Zzx135246'
    end
    it 'user login successfully' do
      post :login, params: { 'username': 'Garrick', 'password': '!Zzx135246' }
      expect(!session[:uid].nil?)
    end
    it 'user login failed with wrong pass' do
      post :login, params: { 'username': 'Garrick', 'password': '!Zzx13524' }
      expect(session[:uid].nil?)
    end
  end
  describe 'user logout account' do
    it 'user successfully logout the account' do
      session[:uid] = 2
      expect(!session[:uid].nil?)
      get :logout
      expect(session[:uid].nil?)
    end
  end
  describe 'User can change an avatar' do
    before(:each) do
      @uid = UserHelper.create_account('GarrickZ2', '123@123.com', '123')
      UserHelper.update_avatar(@uid, '')
    end
    it 'user can change an avatar' do
      session[:uid] = @uid
      post :save_avatar, params: { uid: @uid, index: '4' }
      profile = UserHelper.get_profile @uid
      expect File.basename(profile.avatar) == 'face4.jpg'
    end

    it 'user can not save an avatar if not login ' do
      post :save_avatar, params: { uid: @uid, index: '4' }
      profile = UserHelper.get_profile @uid
      expect File.basename(profile.avatar) != 'face4.jpg'
    end
  end

  describe 'user can update the profile' do
    before(:each) do
      @uid = UserHelper.create_account('GarrickZ2', '123@123.com', '123')
    end
    it 'user can update the city of their profile``' do
      post :update_profile, params: {
        'uid': @uid,
        'city': 'New York'
      }
      profile = UserHelper.get_profile @uid
      expect profile.city == 'New York'
    end
    it 'user cannot update the profile if not exist' do
      post :update_profile, params: {
        'uid': 0,
        'city': 'New York'
      }
      profile = UserHelper.get_profile 0
      expect profile.nil?
    end
  end
  describe 'User can change the password' do
    before(:each) do
      @uid = UserHelper.create_account('GarrickZ2', 'zzx135246@163.com', '!Zzx135246')
    end
    it 'User can change the password successfully' do
      post :update_password, params: {
        uid: @uid,
        o_pass: '!Zzx135246',
        pass: '!Zzx246351',
        c_pass: '!Zzx246351'
      }
      info = UserHelper.get_user_log_info @uid
      expect info[0] == '!Zzx246351'
    end
    it 'User cannot change password is does not exist' do
      post :update_password, params: {
        uid: 0,
        o_pass: '!Zzx135246',
        pass: '!Zzx246351',
        c_pass: '!Zzx246351'
      }
      info = UserHelper.get_user_log_info 0
      expect info[0].nil?
    end

    it 'User cannot change password if original password is wrong' do
      post :update_password, params: {
        uid: @uid,
        o_pass: '!Zzx135245',
        pass: '!Zzx246351',
        c_pass: '!Zzx246351'
      }
      info = UserHelper.get_user_log_info @uid
      expect info[0] == '!Zzx135246'
    end
    it 'User cannot change password if password and confirm does not match' do
      post :update_password, params: {
        uid: @uid,
        o_pass: '!Zzx135246',
        pass: '!Zzx246351',
        c_pass: '!Zzx246352'
      }
      info = UserHelper.get_user_log_info @uid
      expect info[0] == '!Zzx135246'
    end
    it 'User cannot change password if password and confirm does not match' do
      post :update_password, params: {
        uid: @uid,
        o_pass: '!Zzx135246',
        pass: '!Zzx246351',
        c_pass: '!Zzx246352'
      }
      info = UserHelper.get_user_log_info @uid
      expect info[0] == '!Zzx135246'
    end
    it 'User cannot change password if password is not strong enough' do
      post :update_password, params: {
        uid: @uid,
        o_pass: '!Zzx135246',
        pass: 'zzx135246',
        c_pass: 'zzx135246'
      }
      info = UserHelper.get_user_log_info @uid
      expect info[0] == '!Zzx135246'
    end
  end
end
