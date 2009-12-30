Then /^I should see date select for "([^\"]*)"$/ do |name|
  date_select_name = name.gsub(/]$/, "(2i)]")
  response.should have_tag("select[name=?]", date_select_name)
end
