Scenario: Edit username
Given I am on "localhost:3000/users/edit/1"
I fill in "user[name]" with "cucumber test name"
I press "Ok"
I should see "Name: cucumber test name"
