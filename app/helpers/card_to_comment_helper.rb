module CardToCommentHelper
  def self.show_comment(cid)
    comments = CardToComment.show_comment(cid)
    comments_info = []
    comments.each { |comment|
      uid = comment.uid
      content = comment.content
      create_time = comment.create_time
      user = UserProfile.find_by(uid: uid)
      if user.nil?
        username = 'user_not_existed'
        avatar = nil
      else
        username = user.username
        avatar = user.avatar
      end
      comment_info = {
        username: username,
        avatar: avatar,
        content: content,
        create_time: create_time
      }
      comments_info.append(comment_info.to_json)
    }
    comments_info
  end
end
