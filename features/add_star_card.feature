Feature: user copy an existing card
  As a user
  I want to copy an existing card
  so that I can save the problem I like

Background: users and cards in database
  Given the following users exist:
    | username  | password    | email       | uid |
    | jiangzy17 | Jzzy512213! | 123@123.com | 1   |

  Given the following cards exist:
    | cid | uid | title           | source   | description | status | used_time | stars | create_time              | update_time              | schedule_time |
    | 1   | 1   | Two Sum         | LeetCode | easy        | 0      | 0         | 0     | 2022-10-31T04:26:02.000Z | 2022-10-31T04:26:02.000Z | nil           |
    | 2   | 1   | Reverse Integer | LeetCode | medium      | 0      | 30        | 5     | 2022-10-31T04:36:02.000Z | 2022-10-31T06:36:02.000Z | nil           |

@javascript
Scenario: archive a card
  Given I log in with "jiangzy17" and "Jzzy512213!"
  When I click the element with id "nav-card"
  And I click the element with id "nav-sub-all-cards"
  Then I should see "Two Sum"
  When I click the element with id "card-detail-btn-1"
  And I click the element with class ".star-icon"
  And I click the element with class ".star-icon"
  Then I should see "2"