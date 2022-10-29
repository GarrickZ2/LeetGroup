Feature: user create a new card
  As a user
  I want to create a new card
  so that I can record my problem

Background: users in database
  Given the following users exist:
    | username  | password   | email       | uid |
    | Zzx135246 | !Zzx135246 | 123@123.com | 1   |
    | Alien     | !G1535     | zzx@163.com | 2   |

@javascript
Scenario: see the create button in the menu bar
  Given I log in with "Alien" and "!G1535"
  When I click the element with id "createbuttonDropdown"
  Then I should see "New Card"
  When I click the element with id "new-card-btn"
  Then I should see "Title"

@javascript
Scenario: successfully create a card
  Given I log in with "Alien" and "!G1535"
  And I click the element with id "createbuttonDropdown"
  And I click the element with id "new-card-btn"
  Then I fill in card form with "title_test", "source_test", and"description_test"
  And I press "Create"
  Then I should see "Success"

@javascript
Scenario: fail to create a card with an empty title
  Given I log in with "Alien" and "!G1535"
  And I click the element with id "createbuttonDropdown"
  And I click the element with id "new-card-btn"
  Then I fill in card form with "", "source_test", and"description_test"
  And I press "Create"
  Then I should see "Title cannot be empty"

@javascript
Scenario: fail to create a card with a too long title
  Given I log in with "Alien" and "!G1535"
  And I click the element with id "createbuttonDropdown"
  And I click the element with id "new-card-btn"
  Then I fill in card form with "title_testqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq", "source_test", and"description_test"
  And I press "Create"
  Then I should see "length of title cannot exceed"

@javascript
Scenario: fail to create a card with a too long source
  Given I log in with "Alien" and "!G1535"
  And I click the element with id "createbuttonDropdown"
  And I click the element with id "new-card-btn"
  Then I fill in card form with "title_test", "title_testqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqtitle_testqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq", and"description_test"
  And I press "Create"
  Then I should see "length of source cannot exceed"

@javascript
Scenario: fail to create a card with a too long source
  Given I log in with "Alien" and "!G1535"
  And I click the element with id "createbuttonDropdown"
  And I click the element with id "new-card-btn"
  Then I fill in card form with "title_test", "title_test", and"description_testtitle_testqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqtitle_testqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqtitle_testqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqtitle_testqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqtitle_testqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqtitle_testqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq"
  And I press "Create"
  Then I should see "length of description cannot exceed"