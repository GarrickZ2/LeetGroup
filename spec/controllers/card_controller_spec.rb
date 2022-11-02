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

    time1 = '2022-10-31T04:26:02.000Z'
    time2 = '2022-10-31T05:26:02.000Z'
    time3 = '2022-10-31T06:26:02.000Z'

    before(:all) do
      Card.create(uid: '1', title: 'Two Sum', source: 'LeetCode', description: 'easy', schedule_time: nil, status: 1,
                  stars: 1, used_time: 0, create_time: time1, update_time: time1)
      Card.create(uid: '1', title: 'Reverse Integer', source: 'LeetCode', description: 'medium', schedule_time: nil, status: 2,
                  stars: 0, used_time: 0, create_time: time2, update_time: time2)
      Card.create(uid: '1', title: 'Median of Two Sorted Arrays', source: 'LeetCode', description: 'hard', schedule_time: nil, status: 0,
                  stars: 2, used_time: 0, create_time: time3, update_time: time3)
    end

    it 'user does not have any card' do
      post :view, params: {
        uid: '2',
        status: 3,
        page_size: 2,
        offset: 0,
        sort_by: nil,
        sort_type: nil
      }

      card_info = JSON.parse(response.body)['card_info']
      page_info = JSON.parse(response.body)['page_info']
      total_size = JSON.parse(page_info)['total_size']
      expect(card_info.count).to eq 0
      expect(total_size).to eq 0
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

      page_info_expect = {
        total_page: 2,
        total_size: 3,
        current_page: 0,
        current_size: 2
      }

      card_expect = {
        cid: 1,
        uid: 1,
        title: 'Two Sum',
        source: 'LeetCode',
        description: 'easy',
        status: 1,
        used_time: 0,
        stars: 1,
        create_time: time1,
        update_time: time1,
        schedule_time: nil
      }

      card_info = JSON.parse(response.body)['card_info']
      page_info = JSON.parse(response.body)['page_info']
      card1 = JSON.parse(card_info[0])
      expect(card_info.count).to eq 2
      expect(card1.to_json).to eq card_expect.to_json
      expect(page_info).to eq page_info_expect.to_json
    end

    it 'only view active(1) status without sort' do
      post :view, params: {
        uid: '1',
        status: 1,
        page_size: 2,
        offset: 0,
        sort_by: nil,
        sort_type: nil
      }

      page_info_expect = {
        total_page: 1,
        total_size: 1,
        current_page: 0,
        current_size: 1
      }

      card_expect = {
        cid: 1,
        uid: 1,
        title: 'Two Sum',
        source: 'LeetCode',
        description: 'easy',
        status: 1,
        used_time: 0,
        stars: 1,
        create_time: time1,
        update_time: time1,
        schedule_time: nil
      }

      card_info = JSON.parse(response.body)['card_info']
      page_info = JSON.parse(response.body)['page_info']
      card1 = JSON.parse(card_info[0])
      expect(card_info.count).to eq 1
      expect(card1.to_json).to eq card_expect.to_json
      expect(page_info).to eq page_info_expect.to_json
    end

    it 'view all status and sort by update_time desc' do
      post :view, params: {
        uid: '1',
        status: 3,
        page_size: 1,
        offset: 2,
        sort_by: 'update_time',
        sort_type: 'desc'
      }

      page_info_expect = {
        total_page: 3,
        total_size: 3,
        current_page: 2,
        current_size: 1
      }

      card_expect = {
        cid: 1,
        uid: 1,
        title: 'Two Sum',
        source: 'LeetCode',
        description: 'easy',
        status: 1,
        used_time: 0,
        stars: 1,
        create_time: time1,
        update_time: time1,
        schedule_time: nil
      }

      card_info = JSON.parse(response.body)['card_info']
      page_info = JSON.parse(response.body)['page_info']
      card1 = JSON.parse(card_info[0])
      expect(card_info.count).to eq 1
      expect(card1.to_json).to eq card_expect.to_json
      expect(page_info).to eq page_info_expect.to_json
    end

    it 'view all status and sort by create_time desc' do
      post :view, params: {
        uid: '1',
        status: 3,
        page_size: 1,
        offset: 2,
        sort_by: 'create_time',
        sort_type: 'desc'
      }

      page_info_expect = {
        total_page: 3,
        total_size: 3,
        current_page: 2,
        current_size: 1
      }

      card_expect = {
        cid: 1,
        uid: 1,
        title: 'Two Sum',
        source: 'LeetCode',
        description: 'easy',
        status: 1,
        used_time: 0,
        stars: 1,
        create_time: time1,
        update_time: time1,
        schedule_time: nil
      }

      card_info = JSON.parse(response.body)['card_info']
      page_info = JSON.parse(response.body)['page_info']
      card1 = JSON.parse(card_info[0])
      expect(card_info.count).to eq 1
      expect(card1.to_json).to eq card_expect.to_json
      expect(page_info).to eq page_info_expect.to_json
    end

    it 'view all status and sort by stars asc' do
      post :view, params: {
        uid: '1',
        status: 3,
        page_size: 1,
        offset: 1,
        sort_by: 'stars',
        sort_type: 'asc'
      }

      page_info_expect = {
        total_page: 3,
        total_size: 3,
        current_page: 1,
        current_size: 1
      }

      card1_expect = {
        cid: 1,
        uid: 1,
        title: 'Two Sum',
        source: 'LeetCode',
        description: 'easy',
        status: 1,
        used_time: 0,
        stars: 1,
        create_time: time1,
        update_time: time1,
        schedule_time: nil
      }

      card_info = JSON.parse(response.body)['card_info']
      page_info = JSON.parse(response.body)['page_info']
      card1 = JSON.parse(card_info[0])
      expect(card_info.count).to eq 1
      expect(card1.to_json).to eq card_expect.to_json
      expect(page_info).to eq page_info_expect.to_json
    end
  end

  describe 'user views card detail' do
    time1 = '2022-10-31T04:26:02.000Z'
    Card.create(uid: '1', title: 'Two Sum', source: 'LeetCode', description: 'easy', schedule_time: nil, status: 1,
                stars: 1, used_time: 0, create_time: time1, update_time: time1)
    card1_expect = {
      cid: 1,
      uid: 1,
      title: 'Two Sum',
      source: 'LeetCode',
      description: 'easy',
      status: 1,
      used_time: 0,
      stars: 1,
      create_time: time1,
      update_time: time1,
      schedule_time: nil
    }

    it 'should get valid card info' do
      post :view_card_detail, params: {
        uid: 1,
        cid: 1
      }
      card_info = JSON.parse(response.body)['card']
      expect(card_info.to_json).to eq card1_expect.to_json
    end
  end
end