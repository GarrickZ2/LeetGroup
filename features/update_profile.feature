Feature: user update the profile
  As a user
  I want to update my profile information
  So that I can change my information

  Background: users in database
    Given the following users exist:
      | username  | password   | email       | uid |
      | Zzx135246 | !Zzx135246 | 123@123.com | 1   |
      | Alien     | !G1535     | zzx@163.com | 2   |

Scenario: I can goto the profile detail page
  Given I log in with "Alien" and "!G1535"
  When I am on the profile edit page
  Then I should see "Details"

@javascript
Scenario: I can update my profile information
  Given I log in with "Alien" and "!G1535"
  When I am on the profile edit page
  And I click the element with id "edit-tab"
  Then I should see "Save"
  When I fill in "school" with "Columbia University"
  And I click the element with id "save-btn"
  Then I should be on the profile edit page

@javascript
Scenario: I can change my avatar
  Given I log in with "Alien" and "!G1535"
  When I am on the profile edit page
  And I click the element with id "avatar-tab"
  Then I should see "Change your avatar"
  When I click the element with id "i1"
  And I click the element with id "avatar-btn"
  Then I should be on the profile edit page
