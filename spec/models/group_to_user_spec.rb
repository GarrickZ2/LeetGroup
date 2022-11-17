describe GroupToUser do
  describe "Get the status of user role" do
    it 'Get the status of user role' do
      player_status = GroupToUser.role_status
      expect(player_status[:owner]).to eql 0
      expect(player_status[:manager]).to eql 1
    end
  end
end
