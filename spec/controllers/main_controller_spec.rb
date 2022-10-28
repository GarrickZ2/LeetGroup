require 'rails_helper'

describe MainController do
  describe 'User want to goto the main page' do
    it 'user goto the register page if not login' do
      # get :user_index_path, :type => 'register'
      get :dashboard
      expect(response).to redirect_to('/user/index/login')
    end

    it 'user goto the main page if login' do
      session[:uid] = 2
      get :dashboard
      expect(response).to render_template('main/dashboard')
    end
  end
end
