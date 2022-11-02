module MainHelper
  def self.create_session(session, uid)
    session[:uid] = uid
    session[:profile] = UserHelper.get_profile uid
    session[:email] = UserHelper.get_user_log_info(uid)[1]
  end

  def self.clean_session(session)
    session.delete :uid
    session.delete :profile
    session.delete :email
  end
end
