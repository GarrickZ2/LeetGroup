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
    it 'should view card successfully' do
      Card.create_card('1', '123', '123', '123')
      Card.create_card('1', '456', '456', '456')
      puts("debug!!!")
      card_view = Card.view_card(1, 3, 1, 1, nil, nil)
      puts(card_view.card_info.count)
      puts(card_view.page_info.total_page)
    end
  end
end
