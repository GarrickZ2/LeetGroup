class UserProfile < ActiveRecord::Base
  def self.get_profile(uid)
    find_by(uid: uid)
  end
end
