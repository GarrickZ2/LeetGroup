module UserHelper
  def self.check_email_format(email)
    if email =~ URI::MailTo::EMAIL_REGEXP
      true
    else
      false
    end
  end

  def self.check_password_strong(password)
    if password =~ /(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W).{8,}/
      true
    else
      false
    end
  end

  def self.check_username_format(username)
    if username =~ /^\w{6,50}$/
      true
    else
      false
    end
  end

  def self.create_account(username, email, password)
    return -1 if UserLogInfo.exists?(username: username)
    return -2 if UserLogInfo.exists?(email: email)

    UserProfile.create(username: username)
    uid = UserProfile.find_by(username: username).uid
    UserLogInfo.create(username: username, email: email, password: password, uid: uid)
    uid
  end

  def self.login(username, password)
    user = UserLogInfo.find(username)
    if user.password == password
      return user.uid
    else
      return -1
    end
  end

  def self.get_profile(uid)
    UserProfile.get_profile(uid)
  end

end
