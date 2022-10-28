Feature: user create a new card
  As a user
  I want to create a new card
  so that I can record my problem

Scenario: see the create button in the menu bar
  Given I am on the dashboard page
  When I press "Create"
  Then I should see "New Card"
  When  I press "New Card"
  Then I should see "Create New Card"

@javascript
Scenario: successfully create a card
  Given I am on the create new card page
  Then I fill in card form with "title_test", "source_test", and"description_test"
  And I press "Create"
  Then I should see "Successfully created the card"

@javascript
Scenario: fail to create a card with an empty title
  Given I am on the card creation page
  Then I fill in card form with "", "source_test", and"description_test"
  And I press "Create"
  Then I should see "Title cannot be empty"

@javascript
Scenario: fail to create a card with a too long title
  Given I am on the card creation page
  Then I fill in card form with "title_testqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq", "source_test", and"description_test"
  And I press "Create"
  Then I should see "The maximum length cannot exceed 50 characters"

@javascript
Scenario: fail to create a card with a too long source
  Given I am on the card creation page
  Then I fill in card form with "title_test", "title_testqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqtitle_testqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq", and"description_test"
  And I press "Create"
  Then I should see "The maximum length cannot exceed 100 characters"

@javascript
Scenario: fail to create a card with a too long source
  Given I am on the card creation page
  Then I fill in card form with "title_test", "title_test", and"description_testtitle_testqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqtitle_testqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqtitle_testqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqtitle_testqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqtitle_testqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqtitle_testqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq"
  And I press "Create"
  Then I should see "'The maximum length cannot exceed 300 characters"