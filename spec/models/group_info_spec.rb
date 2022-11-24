describe GroupInfo do
  describe 'Group Info status' do
    it "should get the status of group" do
      group_status = GroupInfo.group_status
      expect(group_status[:private]).to eql 0
      expect(group_status[:public]).to eql 1
    end
  end
end
