Feature: user register account
  As a user
  I want to register an account
  So that I can use the website function

  Background: users in database
    Given the following users exist:
      | username  | password   | email       | uid |
      | Zzx135246 | !Zzx135246 | 123@123.com | 1   |
      | Alien     | !G1535     | zzx@163.com | 2   |

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
    And I should see "Username can only contains letter and digits"

  @javascript
  Scenario: Register failed with a wrong format password
    Given I am on the user register page
    Then I fill in register form with "GarrickZ2", "zzx135246@gmail.com", "123123" and "123123"
    And I press "Sign Up Now"
    Then I should be on the user register page
    And I should see "Password has to contains at least 1 Uppercase"

  @javascript
  Scenario: Register failed with a wrong format email
    Given I am on the user register page
    Then I fill in register form with "GarrickZ2", "123com", "!Zzx135246" and "!Zzx135246"
    And I press "Sign Up Now"
    Then I should be on the user register page
    And I should see "Email Format is not correct"

  @javascript
  Scenario: User cannot create an account with the same username
    Given I am on the user register page
    Then I fill in register form with "Zzx135246", "123@163.com", "!Zzx135246" and "!Zzx135246"
    And I press "Sign Up Now"
    Then I should be on the user register page
    And I should see "Username has been taken"


  @javascript
  Scenario: User cannot create an account with the same email
    Given I am on the user register page
    Then I fill in register form with "GarrickZ2", "zzx@163.com", "!Zzx135246" and "!Zzx135246"
    And I press "Sign Up Now"
    Then I should be on the user register page
    And I should see "Email is in used"