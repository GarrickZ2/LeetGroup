# frozen_string_literal: true

# Description
# Used for user_controller to interaction the model and some util
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
    user = UserLogInfo.find_by(username: username)
    return user.uid if !user.nil? && user.password == password

    -1
  end

  def self.get_profile(uid)
    UserProfile.get_profile(uid)
  end

  def self.update_profile(new_profile)
    profile = UserProfile.find_by(uid: new_profile.uid)
    return if profile.nil?

    UserProfile.columns.each do |c|
      type = c.name
      val = new_profile.method(type).call
      profile.method("#{type}=").call val unless val.nil?
    end
    profile.save
  end

  def self.update_avatar(uid, avatar)
    user = UserProfile.find_by(uid: uid)
    user&.update(avatar: avatar)
  end
end
