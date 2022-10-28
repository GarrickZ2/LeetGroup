Then(/^I fill in card form with "([^"]*)", "([^"]*)", and"([^"]*)"$/) do |title, source, description|
  step "I fill in \"r-i-title\" with \"#{title}\""
  step "I fill in \"r-i-source\" with \"#{source}\""
  step "I fill in \"r-i-description\" with \"#{description}\""
end