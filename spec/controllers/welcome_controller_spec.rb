describe WelcomeController do
  describe 'view the welcome page' do
    it 'should view the welcome page' do
      get :index
      expect(response).to render_template 'welcome/index'
    end
  end
end
