class UserToCard < ActiveRecord::Base
  def self.create_user_to_card(uid, cid)
    create(uid: uid, cid: cid)
  end
end
