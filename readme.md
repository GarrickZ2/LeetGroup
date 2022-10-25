# Configuration Database in MySQL
1. Install mysql driver on MacOS
    ```shell
   brew install mysql
   ```
2. Install 'mysql2' driver for Rails by gem
    ```shell
    gem install mysql2
    ```
3. Configure your config file of rails: Under directory config and open 'database.yml'
, change the username and password into your own username and password. Remember including
your password within quotation mark. i.e. password: "your_password"
4. Log into your mysql and create a schema called 'leetgroup_development'
   ```shell
   mysql -u username -p
   [Input your password]
   CREATE SCHEMA leetgroup_development
   ```

