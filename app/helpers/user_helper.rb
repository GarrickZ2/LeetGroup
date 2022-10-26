module UserHelper
  def check_email_format(email)
    if email =~ URI::MailTo::EMAIL_REGEXP
      return true
    else
      return false
    end
  end

  def check_password_strong(password)
    if password =~ /(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W).{8,}/
      return true
    else
      return false
    end
  end

  def check_username_format(username)
    if username =~ /^\w{6,50}$/
      return true
    else
      return false
    end
  end

end
