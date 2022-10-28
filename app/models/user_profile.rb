class UserProfile < ActiveRecord::Base
  def self.login(username, password)
    user = UserLogInfo.find_by(username: username)
    if user.password == password
      return user.uid
    else
      return -1
    end
  end

  def self.get_profile(uid)
    user = self.find_by(uid: uid)
    return user
  end
end
