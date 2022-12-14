class CardToComment < ActiveRecord::Base
  def self.add_comment(uid, cid, content)
    return false if content.size > 500

    create(uid: uid, cid: cid, content: content, create_time: Time.now)
    true
  end

  def self.show_comment(cid)
    CardToComment.where(cid: cid).order('create_time' => :asc)
  end
end

