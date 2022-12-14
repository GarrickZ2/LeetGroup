require 'rails_helper'

describe CardToComment do
  describe 'test add comment' do
    it 'should fail if content is longer than 500 characters' do
      CardToComment.delete_all
      str = 'abcdefghij'
      content = ''
      (1..51).each do |i|
        content += str
      end
      # puts(content.size)
      if_add = CardToComment.add_comment(1, 1, content)
      expect(if_add).to eq false
      expect(CardToComment.count).to eq 0
    end
    it 'should insert a new record in card_to_comment table successfully' do
      CardToComment.delete_all
      if_add = CardToComment.add_comment(1, 1, '')
      expect(if_add).to eq true
      expect(CardToComment.count).to eq 1
    end
  end

  describe 'test show comment' do
    before(:each) do
      CardToComment.delete_all
      CardToComment.create(cid: 1, uid: 1, comment_id: 1, content: 'This problem appears in Google OA', create_time: Time.now)
      CardToComment.create(cid: 2, uid: 2, comment_id: 2, content: 'should use binary search', create_time: Time.now)
      CardToComment.create(cid: 1, uid: 2, comment_id: 3, content: 'should use binary search', create_time: Time.now)
    end
    it 'should get all comments of the card and ordered by create_time' do
      comments = CardToComment.show_comment(1)
      expect(comments.count).to eq 2
      comment1 = comments[0]
      comment2 = comments[1]
      expect(comment1.uid).to eq 1
      expect(comment2.uid).to eq 2
    end
  end
end
