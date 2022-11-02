# Prerequisite
## Packages for cucumber test
```shell
brew install geckodriver
brew install firefox --cask
```
## Configuration Database in MySQL
1. Install mysql driver on MacOS
    ```shell
   brew install mysql
   ```
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

# Production
In order to visit certain versions, please use `git` to checkout to the
corresponding branch. For example, for iteration 1, you should checkout at
```shell
git checkout prod/iter1
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