require 'rails_helper'

describe CardToCommentController do
  describe 'user add a comment' do
    it 'add successfully with valid content' do
      post :add, params: {
        uid: 1,
        cid: 1,
        content: 'Google OA'
      }
      success = JSON.parse(response.body)['success']
      msg = JSON.parse(response.body)['msg']
      expect(success).to eq true
      expect(msg).to eq 'successfully add the comment'
    end
    it 'fail to add with invalid content' do
      str = 'abcdefghij'
      content = ''
      (1..51).each do |i|
        content += str
      end
      post :add, params: {
        uid: 1,
        cid: 1,
        content: content
      }
      success = JSON.parse(response.body)['success']
      msg = JSON.parse(response.body)['msg']
      expect(success).to eq false
      expect(msg).to eq 'content exceeds 500 characters'
    end
  end

  describe 'user view comments' do
    before(:each) do
      UserProfile.delete_all
      UserProfile.create(username: 'MaggieZ', avatar: '/avatar/1..jpg', status: 0, uid: 1)
      CardToComment.create(cid: 1, uid: 1, comment_id: 1, content: 'This problem appears in Google OA', create_time: Time.now)
      CardToComment.create(cid: 2, uid: 2, comment_id: 2, content: 'should use binary search', create_time: Time.now)
      CardToComment.create(cid: 1, uid: 1, comment_id: 3, content: 'should use binary search', create_time: Time.now)
    end

    it 'should return all comments correctly and ordered by create_time' do
      get :show, params: {
        cid: 1
      }
      comments = JSON.parse(response.body)['comments']
      expect(comments.size).to eq 2
      comment1 = comments[0]
      comment2 = comments[1]
      expect(JSON.parse(comment1)['username']).to eq 'MaggieZ'
      expect(JSON.parse(comment2)['username']).to eq 'MaggieZ'
    end

    it 'should set username as user_not_existed if the user is not existed' do
      get :show, params: {
        cid: 2
      }
      comments = JSON.parse(response.body)['comments']
      expect(comments.size).to eq 1
      comment1 = comments[0]
      expect(JSON.parse(comment1)['username']).to eq 'user_not_existed'
    end
  end
end