class UserView
  def initialize(user, role)
    @uid = user.uid
    @username = user.username
    @avatar = user.avatar
    @bio = user.bio
    @work = user.role
    @role = role
  end
  attr_reader :uid, :username, :work, :avatar, :bio, :role
end

class UserResult
  def initialize(result, page)
    @result = result
    @page = page
  end
  attr_reader :result, :page
end
