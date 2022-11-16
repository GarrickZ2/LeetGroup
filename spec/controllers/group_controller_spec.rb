require 'rails_helper'

describe GroupController do
  # one scenario
  describe 'get group info' do
    before(:each) do
      @group = GroupHelper.create_group 1, 'LeetGroup', 'hahah'
    end

    it 'should get group basic info' do
      result = get :get_group_info, params: {
        gid: @group.gid
      }
      data = JSON.parse(result.body)
      expect(data['success']).to eql true
      group_data = JSON.parse(data['data'])
      expect(group_data['name']).to eql 'LeetGroup'
    end

    it 'should not get info of unexsited group' do
      result = get :get_group_info, params: {
        gid: 0
      }
      data = JSON.parse(result.body)
      expect(data['success']).to eql false
    end
  end

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
end