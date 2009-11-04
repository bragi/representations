Given /^the following profiles:$/ do |profiles|
  Profile.create!(profiles.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) profile$/ do |pos|
  visit profiles_url
  within("table > tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following profiles:$/ do |expected_profiles_table|
  expected_profiles_table.diff!(table_at('table').to_a)
end

