Feature:
  As a group member
  I want to join group with code
  So that I can join my friend's group

  Background: database information
    Given the following users exist:
      | username  | password   | email        | uid |
      | Zzx135246 | !Zzx135246 | 123@123.com  | 1   |
      | Alien     | !G1535     | zzx@163.com  | 2   |
      | TomJacky  | !G1535     | zzx2@163.com | 3   |
    Given the following group exist:
      | gid | name      | status |
      | 1   | LeetGroup | 0      |
    Given the following group member exist:
      | gid | uid | role |
      | 1   | 1   | 0    |
      | 1   | 2   | 2    |
    Given the following welcome code exist:
      | code   | gid | uid | status | expiration_date |
      | 123456 | 1   |     | 1      |                 |
      | 654321 | 1   | 4   | 0      |                 |
      | 135246 | 1   | 3   | 0      | 2020-11-15      |

  @javascript
  Scenario: create a group
    Given I log in with "TomJacky" and "!G1535"
    When I click the element with id "createbuttonDropdown"
    And I click the element with id "join-group-btn"
    And I should see "Join Group"
    Then I fill in "invite-code" with "123456"
    And I press "Submit Request"
    Then I should be on the dashboard page
    When I click the element with id "nav-group"
    Then I should see "LeetGroup"


  @javascript
  Scenario: goto a wrong group
    Given I log in with "TomJacky" and "!G1535"
    Then I go to the group page with id 1
    And I should be on the dashboard page

  @javascript
  Scenario: join a private code
    Given I log in with "TomJacky" and "!G1535"
    When I click the element with id "createbuttonDropdown"
    And I click the element with id "join-group-btn"
    And I should see "Join Group"
    Then I fill in "invite-code" with "654321"
    And I press "Submit Request"
    Then I go to the group page with id 1
    And I should be on the dashboard page


  @javascript
  Scenario: join with an expired code
    Given I log in with "TomJacky" and "!G1535"
    When I click the element with id "createbuttonDropdown"
    And I click the element with id "join-group-btn"
    And I should see "Join Group"
    Then I fill in "invite-code" with "135246"
    And I press "Submit Request"
    Then I go to the group page with id 1
    And I should be on the dashboard page


  @javascript
  Scenario: join with an un-existed code
    Given I log in with "TomJacky" and "!G1535"
    When I click the element with id "createbuttonDropdown"
    And I click the element with id "join-group-btn"
    And I should see "Join Group"
    Then I fill in "invite-code" with "133233"
    And I press "Submit Request"
    Then I go to the group page with id 1
    And I should be on the dashboard page

  @javascript
  Scenario: cannot rejoin one group
    Given I log in with "Alien" and "!G1535"
    When I click the element with id "createbuttonDropdown"
    And I click the element with id "join-group-btn"
    And I should see "Join Group"
    Then I fill in "invite-code" with "123456"
    And I press "Submit Request"
    Then I should be on the dashboard page
