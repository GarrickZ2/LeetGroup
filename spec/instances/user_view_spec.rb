describe UserView do
  describe 'Initialize the user view' do
    it 'initialize' do
      user = UserProfile.new
      user.uid = 1
      user.username = 'G'
      user.avatar = '1'
      user.bio = '2'
      view = UserView.new(user, GroupToUser.role_status[:owner])
      expect(view.role).to eql 0
      expect(view.bio).to eql '2'
    end
  end
end

describe UserResult do
  describe 'Initialize the user result' do
    it 'initialize' do
      result = UserResult.new(nil, nil)
      expect(result.result).to eql nil
    end

  end
end