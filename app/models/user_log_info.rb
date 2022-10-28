class UserLogInfo < ActiveRecord::Base

  def self.create_user(username, email, password)
    return -1 if exists?(username: username)

    return -2 if exists?(email: email)

    UserHelper.create_account(username, email, password)

  end
end
