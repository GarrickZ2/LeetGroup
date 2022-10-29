Then(/^I fill in card form with "([^"]*)", "([^"]*)", and"([^"]*)"$/) do |title, source, description|
  step "I fill in \"cardInputTitle\" with \"#{title}\""
  step "I fill in \"cardInputSource\" with \"#{source}\""
  step "I fill in \"cardInputDescription\" with \"#{description}\""
end


