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
  describe 'User can upload an avatar file' do
    before(:each) do
      @uid = UserHelper.create_account('GarrickZ2', '123@123.com', '123')
      @file = fixture_file_upload('public/avatar/default.jpg')
    end
    it 'user can upload an avatar' do
      post :upload_avatar, params: { file: @file }
      expect !session[:temp_avatar].nil?
      expect File.exists? session[:temp_avatar]
    end

    it 'user can not save an avatar if not login ' do
      post :upload_avatar, params: { file: @file }
      get :save_avatar, params: { uid: @uid }
      profile = UserHelper.get_profile @uid
      expect !profile.avatar.nil?
    end

    it 'user can save an avatar after save' do
      session[:uid] = @uid
      post :upload_avatar, params: { file: @file }
      get :save_avatar, params: { uid: @uid }
      profile = UserHelper.get_profile @uid
      expect !profile.avatar.nil?
    end

    describe 'user can update the profile' do
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
  end
end
