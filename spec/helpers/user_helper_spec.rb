require 'rails_helper'

describe UserHelper do
  describe 'user register account' do
    it 'input email with wrong format' do
      expect(UserHelper.check_email_format('abcde!!!')).to eq false
    end

    it 'input email with correct format' do
      expect(UserHelper.check_email_format('abcd@zzz.com')).to eq true
    end

    it 'input username with wrong format' do
      expect(UserHelper.check_username_format('abc')).to eq false
    end

    it 'input username with correct format' do
      expect(UserHelper.check_username_format('abcdddass')).to eq true
    end

    it 'input weak password' do
      expect(UserHelper.check_password_strong('abc')).to eq false
    end

    it 'input strong(correct) password' do
      expect(UserHelper.check_password_strong('Aabc1234567!!')).to eq true
    end

    before(:all) do
      ans = UserHelper.create_account('abcd', 'abcd@bcd.com', 'Abc12345!')
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

  describe 'user retrieve profile' do
    before(:all) do
      UserHelper.create_account('abcd', 'abcd@bcd.com', 'Abc12345!')
    end
    it 'successfully get the profile given uid' do
      user = UserLogInfo.find('abcd')
      result = UserHelper.get_profile(user.uid)
      assert_equal user.username, result.username
    end
  end

  describe 'user update profile with some information' do
    before(:all) do
      @current_uid = UserHelper.create_account('test1', 'test@bcd.com', 'Abc12345!')
    end
    it 'successfully update the profile but NOT username' do
      new_profile = UserProfile.new
      new_profile.uid = @current_uid
      new_profile.username = 'mmab'
      new_profile.city = 'New York'
      UserHelper.update_profile(new_profile)
      user = UserProfile.find(@current_uid)
      assert_equal user.username, 'test1'
      assert_equal user.city, 'New York'
    end

    it 'update the avatar' do
      avatar_path = 'http://www.google.com/'
      UserHelper.update_avatar(@current_uid, avatar_path)
      assert_equal UserProfile.find(@current_uid).avatar, avatar_path
    end
  end

  describe 'user get UserLogInfo' do
    before(:all) do
      @uid = UserHelper.create_account('abcdggt', 'abcdxxa@bcd.com', 'Abc12345!')
    end
    it 'get the corresponding password and email' do
      pwd, em = UserHelper.get_user_log_info(@uid)
      assert_equal 'Abc12345!', pwd
      assert_equal 'abcdxxa@bcd.com', em
    end
  end

  describe 'user update UserLogInfo' do
    before(:all) do
      @uid = UserHelper.create_account('abcdppq', 'abcdmmp@bcd.com', 'Abc12345!')
      UserHelper.create_account('abcde', 'abcde@bcde.com', 'Abc12345!')
    end
    it 'update the information with duplicate' do
      new_log_info = UserLogInfo.new
      new_log_info.uid = @uid
      new_log_info.username = 'abcde'
      new_log_info.password = 'ccccccAmgt!'
      result = UserHelper.update_user_log_info(new_log_info)
      assert_equal false, result
    end

    it 'update the information without duplicate' do
      new_log_info = UserLogInfo.new
      new_log_info.uid = @uid
      new_log_info.username = 'thisisit'
      new_log_info.password = 'ccccccAmgt!'
      new_log_info.email = 'myname@email.com'
      result = UserHelper.update_user_log_info(new_log_info)
      userloginfo = UserLogInfo.find_by(username: 'thisisit')
      assert_equal 'thisisit', userloginfo.username
      assert_equal 'ccccccAmgt!', userloginfo.password
      assert_equal 'myname@email.com', userloginfo.email
      assert_equal @uid, userloginfo.uid
    end
  end

end
