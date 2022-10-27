require 'rails_helper'

describe UserController do
    describe 'user login or signup' do
        it 'user goto the register page' do
            # get :user_index_path, :type => 'register'
            get :index, params: {type: 'register'}
            expect(response).to render_template('user/index')
        end
    end
end