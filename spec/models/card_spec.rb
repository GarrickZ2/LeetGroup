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
end
