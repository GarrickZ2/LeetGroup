class UserLogInfo < ActiveRecord::Base
  @@uid = 1

  def self.create_user(username, email, password)
    return -1 if exists?(username: username)

    return -2 if exists?(email: email)

    create(username: username, email: email, password: password, uid: @@uid)
    UserProfile.create(uid: @@uid, username: username)
    @@uid += 1
    @@uid

  end
end
