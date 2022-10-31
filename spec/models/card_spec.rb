# frozen_string_literal: true
require 'rails_helper'

describe Card do
  describe 'test create card' do
    it 'should insert a new record in card table successfully' do
      cnt = Card.count
      cid = Card.create_card('1', '123', '123', '123')
      expect(Card.count).to eq cnt + 1
    end
  end

  describe 'test view card' do
    time1 = '2022-10-31T04:26:02.000Z'
    time2 = '2022-10-31T05:26:02.000Z'
    time3 = '2022-10-31T06:26:02.000Z'
    Card.create(uid: '1', title: 'Two Sum', source: 'LeetCode', description: 'easy', schedule_time: nil, status: 1,
                stars: 1, used_time: 0, create_time: time1, update_time: time1)
    Card.create(uid: '1', title: 'Reverse Integer', source: 'LeetCode', description: 'medium', schedule_time: nil, status: 2,
                stars: 0, used_time: 0, create_time: time2, update_time: time2)
    Card.create(uid: '1', title: 'Median of Two Sorted Arrays', source: 'LeetCode', description: 'hard', schedule_time: nil, status: 0,
                stars: 2, used_time: 0, create_time: time3, update_time: time3)

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

    it 'no cards' do
      card_view = Card.view_card(2, 3, 1, 0, nil, nil)
      page_info = card_view.page_info
      card_info = card_view.card_info
      expect(card_info.count).to eq 0
      page_info_expect = PageInfo.new(0, 0, 0, 0)
      expect(page_info.to_json).to eq page_info_expect.to_json
    end

    it 'view all status without sort' do
      card_view = Card.view_card(1, 3, 2, 0, nil, nil)
      page_info = card_view.page_info
      card_info = card_view.card_info
      page_info_expect = PageInfo.new(2, 3, 0, 2)
      expect(page_info.to_json).to eq page_info_expect.to_json
      expect(card_info[0].to_json).to eq card1_expect.to_json
    end

    it 'only view active(1) status without sort' do
      card_view = Card.view_card(1, 1, 1, 0, nil, nil)
      page_info = card_view.page_info
      card_info = card_view.card_info
      page_info_expect = PageInfo.new(1, 1, 0, 1)
      expect(page_info.to_json).to eq page_info_expect.to_json
      expect(card_info[0].to_json).to eq card1_expect.to_json
    end

    it 'view all status and sort by update_time desc' do
      card_view = Card.view_card(1, 3, 1, 2, 'update_time', 'desc')
      page_info = card_view.page_info
      card_info = card_view.card_info
      page_info_expect = PageInfo.new(3, 3, 2, 1)
      expect(page_info.to_json).to eq page_info_expect.to_json
      expect(card_info[0].to_json).to eq card1_expect.to_json
    end

    it 'view all status and sort by create_time desc' do
      card_view = Card.view_card(1, 3, 1, 2, 'create_time', 'desc')
      page_info = card_view.page_info
      card_info = card_view.card_info
      page_info_expect = PageInfo.new(3, 3, 2, 1)
      expect(page_info.to_json).to eq page_info_expect.to_json
      expect(card_info[0].to_json).to eq card1_expect.to_json
    end

    it 'view all status and sort by stars asc' do
      card_view = Card.view_card(1, 3, 1, 1, 'stars', 'asc')
      page_info = card_view.page_info
      card_info = card_view.card_info
      page_info_expect = PageInfo.new(3, 3, 1, 1)
      expect(page_info.to_json).to eq page_info_expect.to_json
      expect(card_info[0].to_json).to eq card1_expect.to_json
    end
  end
end
