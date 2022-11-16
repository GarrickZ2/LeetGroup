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

  @javascript
  Scenario: create a public invite code
    Given I log in with "Zzx135246" and "!Zzx135246"
    And I go to the group page with id 1
    And I click the element with id "nav-members-tab"
    Then I should see "Invite"
    When I press "Invite"
    And I press "Generate Code"
    Then I should not see "The code is generated here"



  @javascript
  Scenario: create a private invite code
    Given I log in with "Zzx135246" and "!Zzx135246"
    And I go to the group page with id 1
    And I click the element with id "nav-members-tab"
    Then I should see "Invite"
    When I press "Invite"
    And I click the element with id "private-code"
    And I fill in "invite-username" with "Alien"
    And I press "Generate Code"
    Then I should not see "The code is generated here"