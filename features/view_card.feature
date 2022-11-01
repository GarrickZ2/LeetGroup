Feature: user views cards
  As a user
  I want to view my cards
  so that I can review and edit all the card details

  Background: users in database
    Given the following users exist:
      | username  | password   | email       | uid |
      | Zzx135246 | !Zzx135246 | 123@123.com | 1   |
      | Alien     | !G1535     | zzx@163.com | 2   |

    Given the following cards exist:
      | cid | uid | title           | source   | description | status | used_time | stars | create_time              | update_time              | schedule_time |
      | 1   | 1   | Two Sum         | LeetCode | easy        | 0      | 0         | 0     | 2022-10-31T04:26:02.000Z | 2022-10-31T04:26:02.000Z | nil           |
      | 2   | 1   | Reverse Integer | LeetCode | medium      | 1      | 30        | 5     | 2022-10-31T04:36:02.000Z | 2022-10-31T06:36:02.000Z | nil           |
      | 3   | 1   | Tree Traversal  | LeetCode | hard        | 2      | 40        | 10    | 2022-10-31T03:26:02.000Z | 2022-10-31T04:16:02.000Z | nil           |

  @javascript
  Scenario: see the card button in the side bar
    Given I log in with "Zzx135246" and "!Zzx135246"
    Then I should be on the dashboard page
    When I press "Card"
    Then I should see "All Cards"
    When I press "All Cards"
    Then I should be on the all_cards page

  @javascript
  Scenario: successfully view cards
