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
end