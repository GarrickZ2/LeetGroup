require 'rails_helper'
require 'spec_helper'

describe CardHelper do
  describe 'user creates a card' do
    it 'leave title blank' do
      expect(CardHelper.check_title_empty('')).to eq false
    end

    it 'title is not blank' do
      expect(CardHelper.check_title_empty('123')).to eq true
    end

    it 'input title exceeds maximum length' do
      expect !CardHelper.check_title_length('abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghij')
    end

    it 'input source exceeds maximum length' do
      expect !CardHelper.check_source_length('abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabc
defghijabcdefghijabcdefghijabcdefghijabcdefghij')
    end

    it 'input description exceeds maximum length' do
      expect CardHelper.check_description_length('abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghij
abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghij
abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghij')
    end

    before(:all) do
      CardHelper.create_card('1', 'two-sum', 'leetcode', 'easy')
    end

    describe 'create a card with valid info' do
      it 'should create a card successfully' do
        result = CardHelper.create_card('1', 'two-sum', 'leetcode', 'easy')
        expect(result).to eq true
      end
    end
  end

  describe 'User edit a card' do
    before(:each) do
      Card.create(uid: 23, cid: 22, title: '000', source: '123', description: '321')
    end
    it 'update a card title and description' do
      card = Card.new
      card.uid = 23
      card.cid = 22
      card.title = '111'
      card.description = '000'
      res = CardHelper.update_card(card)
      expect(res).to eql true
      prev_card = Card.find_by(uid: 23, cid: 22)
      expect(prev_card.title == '111' && prev_card.source == '123' && prev_card.description == '000').to eql true
    end
    it 'update a card failed due to non-existence' do
      card = Card.new
      card.uid = 21
      card.cid = 22
      card.title = '111'
      res = CardHelper.update_card(card)
      expect(res).to eql false
    end
  end

  describe 'User delete a card' do
    before(:each) do
      Card.create(uid: 23, cid: 22, title: '000', source: '123', description: '321')
    end

    it 'delete a card successfully' do
      res = CardHelper.delete_card(23, 22)
      expect res
    end

    it 'delete a card failed' do
      res = CardHelper.delete_card(23, 21)
      expect !res
    end
  end

  describe 'User share a card to group' do
    before(:each) do
      GroupToCard.create(gid: 1, cid: 1)
    end

    it 'fail to share if card already exists in group' do
      res = CardHelper.share_card(1, 1)
      expect !res
    end

    it 'successfully share if card is not in group' do
      res = CardHelper.share_card(1, 2)
      expect res
    end
  end

  describe 'User copy a card' do
    before(:all) do
      Card.create(uid: 23, cid: 22, title: '000', source: '123', description: '321')
    end

    it 'fail to copy because this card does not exist' do
      res = CardHelper.copy_card(100, 100)
      expect !res
    end

    it 'successfully copy the card' do
      res = CardHelper.copy_card(50, 22)
      expect res
    end
  end
end
