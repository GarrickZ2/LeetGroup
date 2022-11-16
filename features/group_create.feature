Feature: user create groups
  As a user
  I want to create a group
  So that I can share card with my friend

  Background: users in database
    Given the following users exist:
      | username  | password   | email       | uid |
      | Zzx135246 | !Zzx135246 | 123@123.com | 1   |
      | Alien     | !G1535     | zzx@163.com | 2   |

  @javascript
  Scenario: create a group
    Given I log in with "Zzx135246" and "!Zzx135246"
    When I click the element with id "createbuttonDropdown"
    And I click the element with id "new-group-btn"
    And I should see "Creat New Group"
    Then I fill in "groupInputName" with "LeetGroup"
    When I click the element with id "createGroupButton"
    Then I should be on the dashboard page
    When I click the element with id "nav-group"
    Then I should see "LeetGroup"
#    When I follow "LeetGroup"
#    Then I should see "Group Overview"


