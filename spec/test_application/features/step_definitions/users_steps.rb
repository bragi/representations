Then /^I should see the new user form$/ do
  response.should have_tag("form[action=?][method=post]", users_path)
end

Then /^the new user should be created with:$/ do |data|
  hash = data.hashes.first
  user = User.last
  user.nick.should == hash[:nick] 
  user.profile.name.should == hash[:name] 
  user.profile.surname.should == hash[:surname] 
  user.profile.eye_color.should == hash[:eye_color] 
  user.profile.characteristics.should == hash[:characteristics] 
  user.tasks.first.description.should == hash[:description] 
  user.tasks.first.title.should == hash[:title] 
  user.tasks.first.priority.should == hash[:priority].to_i 
  user.tasks.first.user_id.should == user.id 
end
Then /^the user should have attributes:$/ do |data|
  hash = data.rows_hash
  due_to1 = hash[:due_to1].split(" ")
  due_to2 = hash[:due_to2].split(" ")
  due_to1 = Date.new(y=due_to1[0].to_i, d=due_to1[1].to_i, m=due_to1[2].to_i)
  due_to2 = Date.new(y=due_to2[0].to_i, d=due_to2[1].to_i, m=due_to2[2].to_i)
  @user.nick.should == hash[:nick] 
  @user.profile.name.should == hash[:name] 
  @user.profile.surname.should == hash[:surname] 
  @user.profile.eye_color.should == hash[:eye_color] 
  @user.profile.characteristics.should == hash[:characteristics] 
  @user.tasks.first.description.should == hash[:description1] 
  @user.tasks.first.title.should == hash[:title1] 
  @user.tasks.first.priority.should == hash[:priority1].to_i 
  @user.tasks.first.due_to.should == due_to1
  @user.tasks.first.user_id.should == @user.id 
  @user.tasks.second.description.should == hash[:description2] 
  @user.tasks.second.title.should == hash[:title2] 
  @user.tasks.second.priority.should == hash[:priority2].to_i 
  @user.tasks.first.due_to.should == due_to2
  @user.tasks.second.user_id.should == @user.id 
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
    due_to = hash[:due_to].split(" ")
    due_to = Date.new(y=due_to[0].to_i, d=due_to[1].to_i, m=due_to[2].to_i)
    task = Task.create!(hash.merge!(:due_to => due_to))
    pp task.due_to
    @user.tasks << task
  end
end
When /^I visit this user's edit page$/ do
  visit("users/#{@user.id}/edit")
end
Then /^I should see "([^\"]*)" in the text field "([^\"]*)"$/ do |text, tag_name|
  response.should have_tag("input[type=text][name=?][value=?]", tag_name, text)
end
And /^the "([^\"]*)" radio button should (not )?be checked$/ do |value, _not|
  _not ? checked = false : checked = true
  response.should have_tag("input[type=radio][checked=?][value=?]", checked, value)
end
