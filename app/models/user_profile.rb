class UserProfile < ActiveRecord::Base
  def self.get_profile(uid)
    user = self.find(uid)
    return user
  end
end
