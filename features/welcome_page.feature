Feature: Welcome Page Feature
  As A User
  I want to see the welcome page
  So that I can learn about the product
  and I can further login or register account
  
  
Scenario: See the welcome page
  Given I am on the welcome page
  Then I should see "Find Out More"
  And I should see "Login"
  When I follow "Login"
  Then I should be on the user login page
  And I should see "Sign In"
