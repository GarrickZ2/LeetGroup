When(/^I drag an image into the file zone$/) do
  file = fixture_file_upload('public/avatar/default.jpg')
  post '/user/upload_avatar', file: file
end
