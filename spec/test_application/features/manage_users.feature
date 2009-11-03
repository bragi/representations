#TODO test time representations
Feature: Manage users
  In order to test the app
  Representations should be able to create forms by which one can create, edit, show users
  
  Background:
    Given a user with nick "test_nick"
    And with following profile:
        |name     |surname  |eye_color|characteristics |
        |test_name|test_surname|green|test_characteristics|
    And with following tasks:
        |title   |due_to       |description        |priority| 
        |test_title1|#{Time.now}|test_description1   |1       | 
        |test_title2|#{Time.now}|test_description2   |2       | 

  Scenario: Watching at user's edit page
    When I visit this user's edit page
    Then I should see "test_nick" in the text field "user[nick]"
    And I should see "test_name" in the text field "user[profile_attributes][name]"
    And I should see "test_surname" in the text field "user[profile_attributes][surname]"
    #And I should see "test_characteristics" in the text area "user[profile_attributes][characteristics]"
    And I should see "test_title1" in the text field "user[tasks_attributes][1][title]"
    And I should see "test_description1" in the text field "user[tasks_attributes][1][description]"
    And I should see "1" in the text field "user[tasks_attributes][1][priority]"
    And I should see "test_title2" in the text field "user[tasks_attributes][2][title]"
    And I should see "test_description2" in the text field "user[tasks_attributes][2][description]"
    And I should see "2" in the text field "user[tasks_attributes][2][priority]"
    And the "green" radio button should be checked
    
  Scenario: Creating new user
    Given I am on the new user page
    When I fill in "user[nick]" with "test_nick"
    And I fill in "user[profile_attributes][name]" with "test_name"
    And I fill in "user[profile_attributes][surname]" with "test_surname"
    And I choose "user_profile_eye_color_green"
    And I fill in "user[profile_attributes][characteristics]" with "test_characteristics"
    And I fill in "user[tasks_attributes][new_1][description]" with "task_description"
    And I fill in "user[tasks_attributes][new_1][title]" with "task_title"
    And I fill in "user[tasks_attributes][new_1][priority]" with "1"
    And I press "ok"
    Then the new user should be created with:
        |nick   |name       |surname        |eye_color      |characteristics        |description    |due_to     |title      |priority|
        |test_nick|test_name|test_surname   |green          |test_characteristics   |task_description|2009, 1 1|task_title |1      |

  Scenario: Editing user
    When I visit this user's edit page
    And I fill in "user[profile_attributes][name]" with "test_name"
    And I fill in "user[profile_attributes][surname]" with "test_surname"
    And I choose "user_profile_eye_color_green"
    And I fill in "user[profile_attributes][characteristics]" with "test_characteristics"
    And I press "ok"
    Then the user should have attributes:
        |nick   |name       |surname        |eye_color      |characteristics        |description    |due_to     |title      |priority|
        |test_nick|test_name|test_surname   |green          |test_characteristics   |test_description1|2009, 1 1|test_title1 |1      |
        |   |   |   |   |   |test_description2|2009, 1 1|test_title2 |2      |  
