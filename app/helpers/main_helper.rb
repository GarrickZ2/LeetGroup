module MainHelper
  def self.create_session(session, uid)
    if uid.is_a? String
      uid = uid.to_i
    end
    session[:uid] = uid
    session[:profile] = UserHelper.get_profile uid
    session[:email] = UserHelper.get_user_log_info(uid)[1]
    session[:groups] = GroupHelper.get_user_groups uid
  end

  def self.clean_session(session)
    session.delete :uid
    session.delete :profile
    session.delete :email
    session.delete :groups
  end
end
