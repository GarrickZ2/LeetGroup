Given /the following cards exist/ do |cards_table|
  cards_table.hashes.each do |card|
    Card.create card
  end
end

Given /the following comments exist/ do |comments|
  comments.hashes.each do |comment|
    CardToComment.create comment
  end
end

Then(/^I fill in card form with "([^"]*)", "([^"]*)", and"([^"]*)"$/) do |title, source, description|
  step "I fill in \"cardInputTitle\" with \"#{title}\""
  step "I fill in \"cardInputSource\" with \"#{source}\""
  step "I fill in \"cardInputDescription\" with \"#{description}\""
end

When(/^I click the element with class "([^"]*)"$/) do |cls|
  find(cls).click
end

