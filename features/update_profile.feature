Feature: user login into account
  As a user
  I want to login to my account
  So that I can use the website function

  Background: users in database
    Given the following users exist:
      | username  | password   | email       | uid |
      | Zzx135246 | !Zzx135246 | 123@123.com | 1   |
      | Alien     | !G1535     | zzx@163.com | 2   |

Scenario: I can goto the profile detail page
  Given I log in with "Alien" and "!G1535"
  When I am on the profile edit page
  Then I should see "View Your Profile"

@javascript
Scenario: I can upload the avatar and save it
  Given I log in with "Alien" and "!G1535"
  When I am on the profile edit page
  And I click the element with id "edit-tab"
  Then I should see "Save Your Profile"
  When I fill in "school" with "Columbia University"
  And I click the element with id "save-btn"
  Then I should be on the profile edit page

