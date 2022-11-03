module MainHelper
  def self.create_session(session, uid)
    if uid.is_a? String
      uid = uid.to_i
    end
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
