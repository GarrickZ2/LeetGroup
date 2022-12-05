class CardToComment < ActiveRecord::Base
  def self.add_comment(uid, cid, content)
    return false if content.size > 500

    create(uid: uid, cid: cid, content: content, create_time: Time.now)
    true
  end

  def self.delete_comment(uid, comment_id)
    comment = find_by(comment_id: comment_id)
    return 0 if comment.nil?

    if uid.to_i == comment.uid
      delete(comment)
      return 2
    else
      return 1
    end
  end

  def self.show_comment(cid)
    CardToComment.where(cid: cid).order('create_time' => :asc)
  end
end

