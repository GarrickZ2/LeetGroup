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

  describe 'test view card detail' do
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

    it 'should get card info' do
      card_info = Card.view_card_detail(1, 1)
      expect(card_info.to_json).to eq card1_expect.to_json
    end
  end
end
