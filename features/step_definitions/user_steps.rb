Given /the following users exist/ do |users_table|
  users_table.hashes.each do |user|
    UserLogInfo.create user
    UserProfile.create(username: user['username'], uid: user['uid'])
  end
end


Then(/^I fill in register form with "([^"]*)", "([^"]*)", "([^"]*)" and "([^"]*)"$/) do |username, email, password, repass|
  step "I fill in \"r-i-username\" with \"#{username}\""
  step "I fill in \"r-i-email\" with \"#{email}\""
  step "I fill in \"r-i-password\" with \"#{password}\""
  step "I fill in \"r-i-repass\" with \"#{repass}\""
end

Given(/^I log in with "([^"]*)" and "([^"]*)"$/) do |username, password|
  step 'I am on the user login page'
  step "I fill in \"username\" with \"#{username}\""
  step "I fill in \"password\" with \"#{password}\""
  step 'I press "Sign In"'
end

