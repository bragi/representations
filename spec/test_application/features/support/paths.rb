module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in webrat_steps.rb
  #
  def path_to(page_name)
    case page_name
    
    when /the home\s?page/
      '/'
    when /the new user page/
      #puts new_user_path
      new_user_path
    when /the users page/
      users_path
    when /the new profile page/
      new_profile_path
    
    # Add more mappings here.
    # Here is a more fancy example:
    #
    when /^(.*)'s user page$/i
      user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
