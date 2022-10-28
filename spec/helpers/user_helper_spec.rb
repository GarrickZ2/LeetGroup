require 'rails_helper'

describe UserHelper do
  describe 'user register account' do
    it 'input email with wrong format' do
      expect UserHelper.check_email_format('abcde!!!') == false
    end

    it 'input username with wrong format' do
      expect UserHelper.check_username_format('abc') == false
    end

    it 'input weak password' do
      expect UserHelper.check_password_strong('abc') == false
    end

    before(:all) do
      UserHelper.create_account('abcd', 'abcd@bcd.com', 'Abc12345!')
    end

    describe 'create an account with valid info' do
      it 'should create the account and return uid' do
        result = UserHelper.create_account('abcde', 'abcde@bcd.com', 'Abc12345!')
        expect result >= 0
      end
    end

    describe 'create an account with duplicate username' do
      it 'should return -1' do
        result = UserHelper.create_account('abcd', 'abcde@bcd.com', 'Abc12345!')
        result.eql?(-1)
      end
    end

    describe 'create an account with duplicate email' do
      it 'should return -2' do
        result = UserHelper.create_account('abcde', 'abcd@bcd.com', 'Abc12345!')
        result.eql?(-2)
      end
    end
  end

  describe 'user login account' do
    before(:all) do
      UserHelper.create_account('abcd', 'abcd@bcd.com', 'Abc12345!')
    end
    it 'login with correct username and password' do
      assert_equal UserLogInfo.find('abcd').uid, UserHelper.login('abcd', 'Abc12345!')
    end

    it 'login with wrong password' do
      assert_equal -1, UserHelper.login('abcd', 'Abc123456!')
    end
  end

end
