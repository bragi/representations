Given /^the following users:$/ do |users|
  Users.create!(users.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) users$/ do |pos|
  visit users_url
  within("table > tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following users:$/ do |expected_users_table|
  expected_users_table.diff!(table_at('table').to_a)
end

Then /^I should see the new user form$/ do
  response.should have_tag("form[action=?][method=post]", users_path)
end

Then /^the new user should be created with:$/ do |data|
  hash = data.hashes.first
  user = User.last
  user.nick.should ==(hash[:nick])
  user.profile.name.should ==(hash[:name])
  user.profile.surname.should ==(hash[:surname])
  user.profile.eye_color.should ==(hash[:eye_color])
  user.profile.characteristics.should ==(hash[:characteristics])
  user.tasks.first.description.should ==(hash[:description])
  user.tasks.first.title.should ==(hash[:title])
  user.tasks.first.priority.should ==(hash[:priority].to_i)
  user.tasks.first.user_id.should ==(user.id)
end
Then /^the user should have attributes:$/ do |data|
  hash = data.hashes.first
  hash2 = data.hashes[1] #second one has the data for 2nd task
  @user.nick.should ==(hash[:nick])
  @user.profile.name.should ==(hash[:name])
  @user.profile.surname.should ==(hash[:surname])
  @user.profile.eye_color.should ==(hash[:eye_color])
  @user.profile.characteristics.should ==(hash[:characteristics])
  @user.tasks.first.description.should ==(hash[:description])
  @user.tasks.first.title.should ==(hash[:title])
  @user.tasks.first.priority.should ==(hash[:priority].to_i)
  @user.tasks.first.user_id.should ==(@user.id)
  @user.tasks.second.description.should ==(hash2[:description])
  @user.tasks.second.title.should ==(hash2[:title])
  @user.tasks.second.priority.should ==(hash2[:priority].to_i)
  @user.tasks.second.user_id.should ==(@user.id)
end

Given /^a user with nick "([^\"]*)"$/ do |nick|
  @user = User.create!(:nick => nick)
end
And /^with following profile:$/ do |data|
  hash = data.hashes.first
  profile = Profile.create!(hash)
  @user.profile = profile

end
And /^with following tasks:$/ do |data|
  data.hashes.each do |hash|
    task = Task.create!(hash)
    @user.tasks << task
  end
end
When /^I visit this user's edit page$/ do
  visit("users/#{@user.id}/edit")
end
Then /^I should see "([^\"]*)" in the text field "([^\"]*)"$/ do |text, tag_name|
  response.should have_tag("input[type=text][name=?][value=?]", tag_name, text)
end
Then /^I should see "([^\"]*)" in the text area "([^\"]*)"$/ do |text, tag_name|
  response.should have_tag("text_area[name=?][value=?]", tag_name, text)
end
And /^the "([^\"]*)" radio button should be checked$/ do |value|
  response.should have_tag("input[type=radio][checked=?][value=?]", 'true', value)
end

