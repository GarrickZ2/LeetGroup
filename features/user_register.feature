Feature: user register account
  As a user
  I want to register an account
  So that I can use the website function

Scenario: see the register index
  Given I am on the user register page
  Then I should see "Sign Up"
  And I should see "One of us?"

@javascript
Scenario: success create an account
  Given I am on the user register page
  Then I fill in register form with "GarrickZ", "zzx135246@gmail.com", "!Zzx135246" and "!Zzx135246"
  And I press "Sign Up Now"
  Then I should be on the dashboard page
  Then I should see "Dashboard"

@javascript
Scenario: Register failed with a wrong format username
  Given I am on the user register page
  Then I fill in register form with "ZZX!", "zzx135246@gmail.com", "!Zzx135246" and "!Zzx135246"
  And I press "Sign Up Now"
  Then I should be on the user register page
  And I should see "<param>"
