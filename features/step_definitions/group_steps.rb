
Given /the following group exist/ do |group_info|
  group_info.hashes.each do |group|
    GroupInfo.create group
  end
end

Given /the following group member exist/ do |group_member|
  group_member.hashes.each do |user|
    GroupToUser.create user
  end
end

Given /the following welcome code exist/ do |codes|
  codes.hashes.each do |code|
    GroupWelcomeCode.create code
  end
end
