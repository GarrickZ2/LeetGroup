Feature: comment
  As a user
  I want to comment on a card
  so that I can share my opinion with others

  Background: users and cards in database
    Given the following users exist:
      | username  | password    | email       | uid |
      | jiangzy17 | Jzzy512213! | 123@123.com | 1   |
      | asdfasdf  | Jzzy512213! | 123@321.com | 2   |

    Given the following cards exist:
      | cid | uid | title           | source   | description | status | used_time | stars | create_time              | update_time              | schedule_time |
      | 1   | 1   | Two Sum         | LeetCode | easy        | 0      | 0         | 0     | 2022-10-31T04:26:02.000Z | 2022-10-31T04:26:02.000Z | nil           |
      | 2   | 1   | Reverse Integer | LeetCode | medium      | 0      | 30        | 5     | 2022-10-31T04:36:02.000Z | 2022-10-31T06:36:02.000Z | nil           |
    Given the following comments exist:
      | cid | uid | comment_id | content             | create_time              |
      | 1   | 1   | 1          | I love this card    | 2022-10-31T04:26:02.000Z |
      | 1   | 2   | 2          | Ok, that make sense | 2022-10-31T04:26:02.000Z |

  @javascript
  Scenario: view comments
    Given I log in with "jiangzy17" and "Jzzy512213!"
    When I click the element with id "nav-card"
    And I click the element with id "nav-sub-all-cards"
    When I click the element with id "card-detail-btn-1"
    And I wait for 2 seconds
    Then I should see "I love this card"
    And I should see "Ok, that make sense"

  @javascript
  Scenario: post a comment
    Given I log in with "jiangzy17" and "Jzzy512213!"
    When I click the element with id "nav-card"
    And I click the element with id "nav-sub-all-cards"
    When I click the element with id "card-detail-btn-1"
    And I click the element with id "card-view-comment"
    And I fill in "card-view-comment" with "Post some comments"
    And I click the element with id "comment-save-btn"
    Then I should see "Post some comments"