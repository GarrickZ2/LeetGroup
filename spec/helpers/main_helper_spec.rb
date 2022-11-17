require 'rails_helper'

describe MainHelper do
  describe 'convert uid into integer' do
    it 'should successfully convert uid into integer if it is string type' do
      MainHelper.create_session(session, '1')
      expect(session[:uid]).to eq 1
    end
  end
end 