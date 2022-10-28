Given /the following users exist/ do |users_table|
  users_table.hashes.each do |user|
    UserLogInfo.create user
  end
end


Then(/^I fill in register form with "([^"]*)", "([^"]*)", "([^"]*)" and "([^"]*)"$/) do |username, email, password, repass|
  step "I fill in \"r-i-username\" with \"#{username}\""
  step "I fill in \"r-i-email\" with \"#{email}\""
  step "I fill in \"r-i-password\" with \"#{password}\""
  step "I fill in \"r-i-repass\" with \"#{repass}\""
end