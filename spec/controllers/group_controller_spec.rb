require 'rails_helper'

describe GroupController do
  # one scenario
  describe 'create group' do
    it 'should successfully create the group' do
      # result = post :create_group, params: {
      #   uid: 1,
      #   name: "LeetGroup",
      #   description: "hi"
      # }
      # expect(result[''])
    end
  end

  describe 'view group cards' do
    time1 = '2022-10-31T04:26:02.000Z'
    time2 = '2022-10-31T05:26:02.000Z'
    time3 = '2022-10-31T06:26:02.000Z'

    before(:each) do
      Card.create(cid: 1, uid: 1, title: 'Two Sum', source: 'LeetCode', description: 'easy', schedule_time: nil, status: 1,
                  stars: 1, used_time: 0, create_time: time1, update_time: time1)
      Card.create(cid: 2, uid: 1, title: 'Reverse Integer', source: 'LeetCode', description: 'medium', schedule_time: nil, status: 2,
                  stars: 0, used_time: 0, create_time: time2, update_time: time2)
      Card.create(cid: 3, uid: 2, title: 'Median of Two Sorted Arrays', source: 'LeetCode', description: 'hard', schedule_time: nil, status: 0,
                  stars: 2, used_time: 0, create_time: time3, update_time: time3)
      GroupToCard.create(gid: 1, cid: 1)
      GroupToCard.create(gid: 1, cid: 2)
      GroupToCard.create(gid: 1, cid: 3)
    end

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

    it 'should view cards of all status sorted by create_time in asc' do
      get :view_group_cards, params: {
        gid: 1,
        status: 3,
        page_size: 2,
        offset: 0,
        sort_by: 'create_time',
        sort_type: 'asc'
      }

      page_info_expect = {
        total_page: 2,
        total_size: 3,
        current_page: 0,
        current_size: 2
      }
      card_info = JSON.parse(response.body)['card_info']
      page_info = JSON.parse(response.body)['page_info']
      card = JSON.parse(card_info[0])
      expect(card_info.count).to eq 2
      expect(card.to_json).to eq card_expect.to_json
      expect(page_info).to eq page_info_expect.to_json
    end

    it 'should view cards of all status sorted by create_time in desc' do
      get :view_group_cards, params: {
        gid: 1,
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
      card_info = JSON.parse(response.body)['card_info']
      page_info = JSON.parse(response.body)['page_info']
      card = JSON.parse(card_info[0])
      expect(card_info.count).to eq 1
      expect(card.to_json).to eq card_expect.to_json
      expect(page_info).to eq page_info_expect.to_json
    end

    it 'should view cards of status 1' do
      get :view_group_cards, params: {
        gid: 1,
        status: 1,
        page_size: 1,
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
      card_info = JSON.parse(response.body)['card_info']
      page_info = JSON.parse(response.body)['page_info']
      card = JSON.parse(card_info[0])
      expect(card_info.count).to eq 1
      expect(card.to_json).to eq card_expect.to_json
      expect(page_info).to eq page_info_expect.to_json
    end

    it 'should get nothing if there is no card in the group' do
      get :view_group_cards, params: {
        gid: 2,
        status: 3,
        page_size: 2,
        offset: 0,
        sort_by: nil,
        sort_type: nil
      }

      page_info_expect = {
        total_page: 0,
        total_size: 0,
        current_page: 0,
        current_size: 0
      }
      card_info = JSON.parse(response.body)['card_info']
      page_info = JSON.parse(response.body)['page_info']
      expect(card_info.count).to eq 0
      expect(page_info).to eq page_info_expect.to_json
    end
  end

  describe 'view group card detail' do
    before(:each) do
      @card = Card.create(uid: 23, cid: 22, title: '000', source: '123', description: '321')
    end

    it 'should successfully get the card detail' do
      get :view_group_card_detail, params: {
        gid: 1,
        cid: 22
      }
      card = JSON.parse(response.body)['card']
      expect(card.to_json).to eq @card.to_json
    end
  end

  describe 'check permission' do
    before(:each) do
      Card.create(uid: 3, cid: 22, title: '000', source: '123', description: '321')
      GroupToUser.create(gid: 1, uid: 1, role: GroupToUser.role_status[:owner])
      GroupToUser.create(gid: 1, uid: 2, role: GroupToUser.role_status[:member])
      GroupToUser.create(gid: 1, uid: 3, role: GroupToUser.role_status[:member])
    end

    it 'should return 1 if user is the owner of the group ' do
      get :check_permission, params: {
        gid: 1,
        uid: 1,
        cid: 22
      }
      result = JSON.parse(response.body)['result']
      expect(result).to eq 1
    end

    it 'should return 1 if user is the owner of the card ' do
      get :check_permission, params: {
        gid: 1,
        uid: 3,
        cid: 22
      }
      result = JSON.parse(response.body)['result']
      expect(result).to eq 1
    end

    it 'should return -1 if user is not the owner of the group or the card' do
      get :check_permission, params: {
        gid: 1,
        uid: 2,
        cid: 22
      }
      result = JSON.parse(response.body)['result']
      expect(result).to eq -1
    end
  end

  describe 'delete card' do
    before(:each) do
      GroupToCard.create(gid: 1, cid: 1)
    end

    it 'should get success msg if delete successfully' do
      post :delete_card, params: {
        gid: 1,
        cid: 1
      }
      success = JSON.parse(response.body)['success']
      msg = JSON.parse(response.body)['msg']
      expect(success).to eq true
      expect(msg).to eq 'The card deleted successfully'
    end

    it 'should get failure msg if delete failed' do
      post :delete_card, params: {
        gid: 1,
        cid: 2
      }
      success = JSON.parse(response.body)['success']
      msg = JSON.parse(response.body)['msg']
      expect(success).to eq false
      expect(msg).to eq "The card doesn't exist"
    end
  end
end