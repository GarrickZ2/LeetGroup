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
end