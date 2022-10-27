Feature: user register account
  As a user
  I want to register an account
  So that I can use the website function

Scenario: see the register index
  Given I am on the user register page
  Then I should see "Sign Up"
  And I should see "One of us?"

Scenario: success create an account
  Given I am on the user register page
  Then I fill in "r-i-username" with "GarrickZ"
  And I fill in "r-i-email" with "zzx135246@gmail.com"
  And I fill in "r-i-password" with "!Zzx135246"
  And I fill in "r-i-repass" with "!Zzx135246"
  And I pending implementation
  And I press "register-btn"
  Then I should be on the dashboard page
  Then I should see "Dashboard"

