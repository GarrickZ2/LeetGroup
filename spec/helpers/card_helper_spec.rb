require 'rails_helper'
require 'spec_helper'

describe CardHelper do
  describe 'user creates a card' do
    it 'leave title blank' do
      expect CardHelper.check_title_empty("")== false
    end

    it 'title is not blank' do
      expect CardHelper.check_title_empty("123")== true
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


end