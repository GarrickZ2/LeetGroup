require 'rails_helper'

describe UserLogInfo do

  before(:all) do
    UserLogInfo.create_user("abcd", "abcd@bcd.com", "Abc12345!")
  end

  describe 'create an account with valid info' do
    it 'should create the account and return uid' do
      result = UserLogInfo.create_user("abcde", "abcde@bcd.com", "Abc12345!")
      expect result >= 0
    end
  end

  describe "create an account with duplicate username" do
    it 'should return -1' do
      result = UserLogInfo.create_user("abcd", "abcde@bcd.com", "Abc12345!")
      result.eql? -1
    end
  end

  describe "create an account with duplicate email" do
    it 'should return -2' do
      result = UserLogInfo.create_user("abcde", "abcd@bcd.com", "Abc12345!")
      result.eql? -2
    end
  end
end