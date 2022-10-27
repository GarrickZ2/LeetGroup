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

end
