describe GroupWelcomeCode do
  describe "get the status of welcome code" do
    it 'get the status of welcome code' do
      status_map = GroupWelcomeCode.welcome_type
      expect(status_map[:private]).to eql 0
      expect(status_map[:public]).to eql 1
    end
  end
end
