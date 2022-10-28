require 'rails_helper'

describe UserHelper do
  describe 'user register account' do
    it 'input email with wrong format' do
      expect UserHelper.check_email_format("abcde!!!") == false
    end

    it 'input username with wrong format' do
      expect UserHelper.check_username_format("abc") == false
    end

    it 'input weak password' do
      expect UserHelper.check_password_strong("abc") == false
    end
  end


end