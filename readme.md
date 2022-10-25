# Configuration Database in MySQL
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
   CREATE SCHEMA leetgroup_development
   ```
