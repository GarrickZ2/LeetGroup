require 'rails_helper'

describe CardController do
  describe 'user creates a card with valid info' do
    it 'user enter correct info' do
      post :create, params: {
        uid: '1',
        title: 'three-sum',
        source: 'leetcode',
        description: ''
      }
      success = JSON.parse(response.body)['success']
      msg = JSON.parse(response.body)['msg']
      expect(success).to eq true
      expect(msg).to eq nil
    end
  end

  describe 'user creates a card with invalid info' do
    it 'user leaves title blank' do
      post :create, params: {
        uid: '1',
        title: '',
        source: 'leetcode',
        description: ''
      }
      success = JSON.parse(response.body)['success']
      msg = JSON.parse(response.body)['msg']
      expect(success).to eq false
      expect(msg).to eq 'Title cannot be empty'
    end
    it 'title exceeds maximum length' do
      post :create, params: {
        uid: '1',
        title: 'abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghij',
        source: 'leetcode',
        description: ''
      }
      success = JSON.parse(response.body)['success']
      msg = JSON.parse(response.body)['msg']
      expect(success).to eq false
      expect(msg).to eq 'The maximum length of title cannot exceed 50 characters'
    end
    it 'source exceeds maximum length' do
      post :create, params: {
        uid: '1',
        title: '123',
        source: 'abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabc
defghijabcdefghijabcdefghijabcdefghijabcdefghij',
        description: ''
      }
      success = JSON.parse(response.body)['success']
      msg = JSON.parse(response.body)['msg']
      expect(success).to eq false
      expect(msg).to eq 'The maximum length of source cannot exceed 100 characters'
    end
    it 'description exceeds maximum length' do
      post :create, params: {
        uid: '1',
        title: '123',
        source: 'leetcode',
        description: 'abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefg
hijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdef
ghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghij'
      }
      success = JSON.parse(response.body)['success']
      msg = JSON.parse(response.body)['msg']
      expect(success).to eq false
      expect(msg).to eq 'The maximum length of description cannot exceed 300 characters'
    end
  end

  describe 'user views cards' do
    before(:each) do
      # insert a registered user
      Card.create(uid: '1', title: 'Two Sum', source: 'LeetCode', description: 'easy', schedule_time: nil, status: 1,
        stars: 1, used_time: 0, create_time: Time.now, update_time: Time.now)
      Card.create(uid: '1', title: 'Reverse Integer', source: 'LeetCode', description: 'medium', schedule_time: nil, status: 2,
                  stars: 0, used_time: 0, create_time: Time.now, update_time: Time.now)
      Card.create(uid: '1', title: 'Median of Two Sorted Arrays', source: 'LeetCode', description: 'hard', schedule_time: nil, status: 0,
                  stars: 2, used_time: 0, create_time: Time.now, update_time: Time.now)
    end

    it 'view all status without sort' do
      post :view, params: {
        uid: '1',
        status: 3,
        page_size: 2,
        offset: 0,
        sort_by: nil,
        sort_type: nil
      }

      card_info = JSON.parse(response.body)['card_info']
      page_info = JSON.parse(response.body)['page_info']
      total_size = JSON.parse(page_info)['total_size']
      expect(card_info.count).to eq 2
      expect(total_size).to eq 3
    end
  end
end