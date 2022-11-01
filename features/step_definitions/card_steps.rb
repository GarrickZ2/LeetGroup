Given /the following cards exist/ do |cards_table|
  cards_table.hashes.each do |card|
    Card.create card
  end
end

Then(/^I fill in card form with "([^"]*)", "([^"]*)", and"([^"]*)"$/) do |title, source, description|
  step "I fill in \"cardInputTitle\" with \"#{title}\""
  step "I fill in \"cardInputSource\" with \"#{source}\""
  step "I fill in \"cardInputDescription\" with \"#{description}\""
end


