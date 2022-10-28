require 'rails_helper'

describe MainController do
  describe 'user login or signup' do
    it 'user goto the register page' do
      # get :user_index_path, :type => 'register'
      get :dashboard
      expect(response).to render_template('main/dashboard')
    end
  end
end
