#TODO test time representations
Feature: Test  user forms generated by Representations
  In order to test the app
  Representations should be able to create forms by which one can create, edit, show users
  
  Background:
    Given a user with nick "test_nick"
    And with following profile:
        |name     |surname  |eye_color|characteristics |
        |test_name|test_surname|green|test_characteristics|
    And with following tasks:
        |title   |due_to       |description        |priority| 
        |test_title1|2009 1 1|test_description1   |1       | 
        |test_title2|2009 2 2|test_description2   |2       | 

  Scenario: Watching at user's show page
    When I visit this user's show page
    Then I should see "test_nick" for "Nick"
    And I should see "test_name" for "Name"
    And I should see "test_surname" for "Surname"
    And I should see "test_characteristics" for "Characteristics"
    And I should see "test_title1" for "Title"
    And I should see "test_description1" for "Description"
    And I should see "1" for "Priority"
    And I should see "test_title2" for "Title"
    And I should see "test_description2" for "Description"
    And I should see "2" for "Priority"
    And I should see "green" for "Eye color"
    And I should see "2009-01-01" for "Due to"
    And I should see "2009-02-02" for "Due to"
    
  Scenario: Creating new user
    Given I am on the new user page
    When I fill in "user[nick]" with "test_nick"
    And I fill in "user[profile_attributes][name]" with "test_name"
    And I fill in "user[profile_attributes][surname]" with "test_surname"
    And I choose "user_profile_eye_color_green"
    And I fill in "user[profile_attributes][characteristics]" with "test_characteristics"
    And I fill in "user[tasks_attributes][new_0][description]" with "task_description"
    And I fill in "user[tasks_attributes][new_0][title]" with "task_title"
    And I fill in "user[tasks_attributes][new_0][priority]" with "1"
    And I press "ok"
    Then the new user should be created with:
        |nick   |name       |surname        |eye_color      |characteristics        |description    |due_to     |title      |priority|
        |test_nick|test_name|test_surname   |green          |test_characteristics   |task_description|2009, 1 1|task_title |1      |
  #Unfinished - add filling tasks data
  Scenario: Editing user
    When I visit this user's edit page
    And I fill in "user[nick]" with "another test_nick"
    And I fill in "user[profile_attributes][name]" with "another test_name"
    And I fill in "user[profile_attributes][surname]" with "another test_surname"
    And I choose "user_profile_eye_color_green"
    And I fill in "user[profile_attributes][characteristics]" with "another test_characteristics"
    And I select "March" from "user[tasks_attributes][0][due_to(2i)]"
    And I press "ok"
    Then the user should have attributes:
        |nick           |another test_nick|
        |name           |another test_name|
        |surname        |another test_surname|
        |eye_color      |green|
        |characteristics|another test_characteristics|
        |title1         |test_title1|
        |title2         |test_title2|
        |priority1      |1|
        |priority2      |2|
        |description1   |test_description1|
        |description2   |test_description2|
        |due_to1        |2009 3 1|
        |due_to2        |2009 2 2|
