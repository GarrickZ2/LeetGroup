Feature: user login into account
  As a user
  I want to login to my account
  So that I can use the website function

  Background: users in database
    Given the following users exist:
      | username  | password   | email       | uid |
      | Zzx135246 | !Zzx135246 | 123@123.com | 1   |
      | Alien     | !G1535     | zzx@163.com | 2   |

Scenario: see the login page
  Given I am on the user login page
  Then I should see "Sign In"
  And I should see "New here?"
  
Scenario: Login the account successfully
  Given I am on the user login page
  When I fill in "username" with "Zzx135246"
  And I fill in "password" with "!Zzx135246"
  And I press "Sign In"
  Then I should be on the dashboard page

Scenario: Login the account failed with wrong pass
  Given I am on the user login page
  When I fill in "username" with "Zzx135246"
  And I fill in "password" with "!Zzx"
  And I press "Sign In"
  Then I should be on the user login page

Scenario: User don't need to login account again
  Given I am on the user login page
  When I fill in "username" with "Zzx135246"
  And I fill in "password" with "!Zzx135246"
  And I press "Sign In"
  Then I should be on the dashboard page
  When I go to the user login page
  Then I should be on the dashboard page

Scenario: User cannot directly goto dashboard page
  When I go to the dashboard page
  Then I should be on the user login page

Scenario: User can logout from dashboard
  Given I log in with "Alien" and "!G1535"
  Then I should be on the dashboard page
  When I click the element with id "logout-btn"
  Then I should be on the user login page