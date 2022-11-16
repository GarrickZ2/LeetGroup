module MainHelper
  @@session_list = [:uid, :profile, :email, :groups]
  def self.create_session(session, uid)
    uid = uid.to_i if uid.is_a? String
    session[:uid] = uid
    session[:profile] = UserHelper.get_profile uid
    session[:email] = UserHelper.get_user_log_info(uid)[1]
    session[:groups] = GroupHelper.get_user_groups uid
  end

  def self.check_session(session)
    @@session_list.each do |attr|
      return false if session[attr].nil?
    end
    true
  end

  def self.clean_session(session)
    session.delete :uid
    session.delete :profile
    session.delete :email
    session.delete :groups
  end
end
