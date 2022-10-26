class UserLogInfo < ActiveRecord::Base
  @@uid = 1
  def self.create_user(username, email, password)
    if self.exists?(:username => username)
      return -1
    end

    if self.exists?(:email => email)
      return -2
    end
    self.create(username: username, email: email, password: password, uid: @@uid)
    @@uid += 1
    return @@uid

  end
end