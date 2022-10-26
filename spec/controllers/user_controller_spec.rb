require 'rails_helper'

describe UserController do
    describe 'user login or signup' do
        it 'user goto the register page' do
            # get :user_index_path, :type => 'register'
            get :main_dashboard_path
            expect(response).to render_template('main/dashboard')
        end
    end
end