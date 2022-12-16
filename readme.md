# Team Member
- Lulu Zhang (lz2761)
- Zixuan Zhang (zz2888)
- Ruyue Wang (rw2905)
- Ziyuan Jiang (zj2322)

# Heroku website
https://warm-meadow-85532.herokuapp.com/

# GitHub repository link
https://github.com/GarrickZ2/LeetGroup

**IMPORTANT:** Our final version code is in `proj-launch` branch.

# Detailed Feature Instruction

| Feature                      | Link                                           |
| ---------------------------- | ---------------------------------------------- |
| User Related Feature         | [Here](feature_readme/user_feature.md)         |
| Profile Related Feature      | [Here](feature_readme/profile_feature.md)      |
| Card Related Feature         | [Here](feature_readme/card_feature.md)         |
| Group Related Feature        | [Here](feature_readme/group_feature.md)        |
| Group Member Related Feature | [Here](feature_readme/group_member_feature.md) |
| Group Card Related Feature   | [Here](feature_readme/group_card_feature.md)   |

# Features of Project Launch
- On group's home page, there is a red button called `Destroy Group`, click it and a small window will pop up asking you
  to confirm. By clicking the yes, this group will be destroyed.
- On the dashboard page, short-cuts for commonly used functionalities are added for quicker access. We have the
  shortcuts for viewing profile, changing password, creating new cards, viewing all cards, and joining group. We also 
  add the group overview information on dashboard.
- After you go to `Card-All Cards` page, you will see all the cards you've created. Click any card, you will see `Finish!`
  button at the right side. Click it and this card will be transferred to `Finished Cards` tab.
- Under the `Card` tab of navigation bar, we add a sub-tab called `Finished Cards`, which stores all the cards that
  user marks as finished. Finished cards will not show in `Card-All Cards` page. 
# Features of iteration 2
- After a user login, on the **top right** corner, there is a green button called `+ create`, click it
  and you can click `create group` to create a group.
  - Inside the group create modal, you need to enter the group name, group type (public/private) and the
  description of the group.
-  You can also click `join group` to join the group, by entering the invitation code that the group member gave you.
- On the left side, when you navigate to the all card pages, and click a certain card for details, you will be able
  to: 
  - `share` the card to any group that you have joined.
  - `delete` the card from your collection.
  
- When you are in a group, click group - [your group name] to the group main page.
  - You will firstly see the overview of the group (to be implemented in the final iteration).
  - Click `card` tab to see all the group cards, where you can click every card to see the details:
    - You can delete the card from the group if and only if you are the owner of the group, or you created(own) this card.
  - Click `member` tab to see all the members in the group. You can: 
    - If you are the owner of the group, you can delete people from the group.
    - As a team member, you can click `invite` to invite others to your group. This is done by selecting the
      features of the invitation code (expiration date, public/private), and then the system will generate a code for you,
      and people can use the link to join the group.
      - If it is set to be private, you should enter the username in order to generate the code.
# Features of iteration 1
- When you go to the welcome page, please click the button on **top right**. And then choose
either `Login` or `Signup`. This will take you to the login/signup page.
- If you don't have account, please sign up first. Notice that we apply some constraints to the information you enter, 
including strong password, valid email format.
- Sign in and you will be redirected to the `dashboard`. After logging in, you can always do the following things with our layout:
  - Click **top right** button with your username, you can either choose to view your profile or logout.
    - If you are in the profile page, you can (1) `Edit Avatar`, (2) `View Profile`, (3) `Edit Profile`.
  - Next to that button, you will find a green button called `+ Create` on **top right**, and then click `New Card`. This will lead you to the card
  creation page.
  - Click the three dots next to your profile on the left side, you can change your password.
  - There is a navigation bar on the left, you can always go to `Dashboard` or `Card-All cards`.
- In the card creation page, you can enter the details and create the card.
- After you go to `Card-All cards` page, you will see all the cards you've created. You can then click `See detail` to
view the details of each card.

Any button/feature/view that is not mentioned above has not been implemented in this iteration.
# Prerequisite
## Packages for cucumber test
For MacOS, Linux:
```shell
brew install geckodriver
brew install firefox --cask
```
For Windows, follow the instruction [here](http://www.learningaboutelectronics.com/Articles/How-to-install-geckodriver-Python-windows.php) for `geckodriver` installation,
and [here](https://support.mozilla.org/en-US/kb/how-install-firefox-windows) for Firefox.
## Configuration Database in MySQL
1. Install mysql driver on MacOS/Linux
    ```shell
   brew install mysql
   ```
   For Windows users, refer to this [instruction](https://dev.mysql.com/doc/refman/5.7/en/installing-mysql-shell-windows-quick.html).

2. Install 'mysql2' driver for Rails by gem
    ```shell
    gem install mysql2
    ```
3. Configure the password of mysql: open `terminal` and type 
    ```
    export MY_SQL_PWD=[YOUR_SQL_PASSWORD]
    ```
    For example, 
    ```
    export MY_SQL_PWD=leetgroup123!
    ````
    This will create an environment variable locally which will be used in `config/database.yml` file.
4. Log into your mysql and create a schema called 'leetgroup_development'
   ```shell
   mysql -u username -p
   [Input your password]
   CREATE SCHEMA leetgroup_development;
   CREATE SCHEMA leetgroup_test;
   ```

# Development instruction (Run and Test)
This part includes steps to run the application locally. Before running the following commands,
you need to clone the repo locally. 
1. Checkout to the correct branch.
```shell
git checkout proj-iter2
```
2. Install gems
```shell
bundle install --without production
```
3. Setup database
```shell
rake db:seed
rake db:migrate
```
4. Run the Ruby application
```shell
rails s
```
If anything goes wrong, please make sure your Ruby version is 2.6.6

5. Test the application
```shell
bundle exec cucumber
bundle exec rspec
```
Go to `coverage/index.html` for coverage report.

**IMPORTANT NOTICE:** Since we are using Firefox for cucumber test, sometimes the test will be stuck and not responding. In this case,
please terminate the process and rerun `bundle exec cucumber`, it should pass all the tests afterwards.
# Production
This part will inform you how to deploy the code to heroku.

In order to visit certain versions, please use `git` to checkout to the
corresponding branch. For example, for iteration 1, you should checkout at
```shell
git checkout proj-iter1
```

## Step 1: Push and deploy
To deploy our application to Heroku, you first need to create an account on the [website](https://www.heroku.com/).
After that, please refer to [this page](https://devcenter.heroku.com/articles/git)
for creating, and deploying the application.

One thing to notice is that we are **NOT** pushing `master` branch to heroku, so please use
```shell
git push heroku <branch_name>:master
```

## Step 2: Database creation
After deployment, use `heroku addons` to check if `heroku-postgresql` appears in the add-ons.
If not, run this command:
```shell
heroku addons:create heroku-postgresql:hobby-dev
```

This will help you add Postgres to the app. Then you should run the following commands to build the databases remotely.
```shell
heroku run rake db:seed
heroku run rake db:migrate
```

You should be able to run the app on heroku now.

# Utils
## LeetLogger
### Usage
Get the logger by LeetLogger.get_logger class_name file_path
```ruby
class Movies
   def index
    logger = LeetLogger.get_logger Movies.name 'index.log' 
    logger.info "information"
    logger.warn 'warning'
    logger.error 'error info'
    end
end
```
1. All the log info will be record under the file log/index.log
2. If you want to declare multi level log name, you can use level1/level2/index.log, etc.
3. If you don't give the file name, all the log information will be recorded in the 'other.log'
4. If you don't give the class_name, we will use 'Default' as instead.
5. You must give the class_name before the file_path

### Extension in RubyMine
To highlight the log file, you can download the extension 'Ideolog',
and import the log highlighting setting under config/leetlogger.xml
