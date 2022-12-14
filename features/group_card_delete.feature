Feature: Delete Card From Group
  As a group member
  I want to delete a group card
  So that I can keep group card pool with high quality

  Background: database information
    Given the following users exist:
      | username  | password   | email       | uid |
      | Zzx135246 | !Zzx135246 | 123@123.com | 1   |
      | Alien     | !G1535     | zzx@163.com | 2   |
    Given the following group exist:
      | gid | name      | status |
      | 1   | LeetGroup | 0      |
      | 2   | Saas      | 0      |
    Given the following group member exist:
      | gid | uid | role |
      | 1   | 1   | 0    |
      | 1   | 2   | 2    |
      | 2   | 1   | 2    |
      | 2   | 2   | 0    |
    Given the following cards exist:
      | cid | uid | title           | source   | description | status | used_time | stars | create_time              | update_time              | schedule_time |
      | 1   | 1   | Two Sum         | LeetCode | easy        | 0      | 0         | 0     | 2022-10-31T04:26:02.000Z | 2022-10-31T04:26:02.000Z | nil           |
      | 2   | 1   | Reverse Integer | LeetCode | medium      | 1      | 30        | 5     | 2022-10-31T04:36:02.000Z | 2022-10-31T06:36:02.000Z | nil           |
      | 3   | 1   | Tree Traversal  | LeetCode | hard        | 2      | 40        | 10    | 2022-10-31T03:26:02.000Z | 2022-10-31T04:16:02.000Z | nil           |
    Given the following group cards exist:
      | gid | cid |
      | 1   | 1   |

  @javascript
  Scenario: Delete the card successfully
    Given I log in with "Zzx135246" and "!Zzx135246"
    Then I go to the group page with id 1
    And I click the element with id "nav-group-cards-tab"
    Then I should see "Two Sum"
    When I click the element with id "card-detail-btn-1"
    Then I should see "LeetCode"
    When I click the element with id "delete-group-card-btn"
    And I press "Yes"
    Then I should not see "Two Sum"

  @javascript
  Scenario: No permission to delete card
    Given I log in with "Alien" and "!G1535"
    Then I go to the group page with id 1
    And I click the element with id "nav-group-cards-tab"
    When I click the element with id "card-detail-btn-1"
    Then I should see "LeetCode"
    When I click the element with id "delete-group-card-btn"
    Then I should see "Sorry, you don't have the permission to delete this card"
