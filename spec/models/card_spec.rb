require 'rails_helper'

describe Card do
  describe "test create card"  do
    it "should insert a new record in card table successfully" do
      cid = Card.create_card("1", "123", "123", "123")
      expect(cid).to eq 1
    end
  end
end