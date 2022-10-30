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

  def self.update_profile(uid, username, school, company, bio, city)
    user = UserProfile.find(uid)
    username = user.username if username.nil?
    school = user.school if school.nil?
    company = user.school if company.nil?
    bio = user.bio if bio.nil?
    city = user.city if city.nil?
    user.update(username: username, school: school, company: company, bio: bio, city: city)
  end

  def self.update_avatar(uid, avatar)
    user = UserProfile.find(uid)
    user.update(avatar: avatar)
  end
end
