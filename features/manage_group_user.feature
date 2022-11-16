Feature:
  As a group member
  I want to invite other into groups
  So that I can share card with my friend

  Background: users in database
    Given the following users exist:
      | username  | password   | email       | uid |
      | Zzx135246 | !Zzx135246 | 123@123.com | 1   |
      | Alien     | !G1535     | zzx@163.com | 2   |
    Given the following group exist:
      | gid | name      | status |
      | 1   | LeetGroup | 0      |
    Given the following group member exist:
      | gid | uid | role |
      | 1   | 1   | 0    |
      | 1   | 2   | 2    |

  @javascript
  Scenario: leave a group
    Given I log in with "Alien" and "!G1535"
    And I go to the group page with id 1
    And I click the element with id "nav-members-tab"
    When I press "Leave Group"
    And I wait for 3 seconds
    Then I should be on the dashboard page

  @javascript
  Scenario: remove a user
    Given I log in with "Zzx135246" and "!Zzx135246"
    And I go to the group page with id 1
    And I click the element with id "nav-members-tab"
    Then I should see "Alien"
    When I press "Remove"
    And I wait for 3 seconds
    Then I should not see "Alien"

  @javascript
  Scenario: change user role to manager
    Given I log in with "Zzx135246" and "!Zzx135246"
    And I go to the group page with id 1
    And I click the element with id "nav-members-tab"
    Then I should see "Alien"
    When I press "Member"
    And I click the element with id "change-to-manager"
    And I wait for 3 seconds
    Then I should see "Manager"


  @javascript
  Scenario: change user role to owner
    Given I log in with "Zzx135246" and "!Zzx135246"
    And I go to the group page with id 1
    And I click the element with id "nav-members-tab"
    Then I should see "Alien"
    When I press "Member"
    And I click the element with id "change-to-owner"
    And I wait for 3 seconds
    Then I should see "Owner"
