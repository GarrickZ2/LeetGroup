Feature: user update password
  As a user
  I want to change my password
  so that I can change my password

Background: users in database
  Given the following users exist:
    | username  | password   | email       | uid |
    | Zzx135246 | !Zzx135246 | 123@123.com | 1   |
    | Alien     | !G1535     | zzx@163.com | 2   |

Scenario: change the password successfully
  Given I log in with "Alien" and "!G1535"
  Then I am on the password change page
  And I fill in "o-pass" with "!G1535"
  And I fill in "pass" with "!Zzx135246"
  And I fill in "c-pass" with "!Zzx135246"
  And I press "Submit"
  Then I should be on the user login page


Scenario: change the password failed due to weak new pass
  Given I log in with "Alien" and "!G1535"
  Then I am on the password change page
  And I fill in "o-pass" with "!G1535"
  And I fill in "pass" with "123456"
  And I fill in "c-pass" with "123456"
  And I press "Submit"
  Then I should be on the password change page

Scenario: change the password failed due to not match with original password
  Given I log in with "Alien" and "!G1535"
  Then I am on the password change page
  And I fill in "o-pass" with "!G"
  And I fill in "pass" with "123456"
  And I fill in "c-pass" with "123456"
  And I press "Submit"
  Then I should be on the password change page

  Scenario: change the password failed due to not match with new password
    Given I log in with "Alien" and "!G1535"
    Then I am on the password change page
    And I fill in "o-pass" with "!G1535"
    And I fill in "pass" with "!Zzx135246"
    And I fill in "c-pass" with "123456"
    And I press "Submit"
    Then I should be on the password change page
