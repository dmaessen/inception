#!/bin/bash

# Setup directories and permissions
mkdir -p /run/mysqld
chown -R mysql:mysql /var/lib/mysql /run/mysqld
chmod 755 /var/lib/mysql /run/mysqld

# Initialize the database if it doesn't exist
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB system tables..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql -skip-show-database --auth-root-authentication-method=normal --verbose

    echo "Checking directory permissions..."
    ls -ld /var/lib/mysql /var/log/mysql /run/mysqld

    if [ $? -ne 0 ]; then
        echo "Failed to initialize MariaDB system tables. Check /var/log/mysql/error.log for details."
        ls -la /var/lib/mysql  # To see ownership and permissions
        exit 1
    fi

    # Start MariaDB temporarily to create database and users
    service mariadb start
    mysql -e "
        CREATE DATABASE IF NOT EXISTS $MDB_NAME;
        CREATE USER IF NOT EXISTS '$MDB_USER'@'%' IDENTIFIED BY '$MDB_PASSWORD';
        GRANT ALL PRIVILEGES ON *.* TO '$MDB_USER'@'%';
        FLUSH PRIVILEGES;
    "
    service mariadb stop
fi

echo "MariaDB is ready!"
exec gosu mysql "$@"





# Check if the specified database (defined in .env) directory exists
# if [ -d "/var/lib/mysql/$MDB_NAME" ]; then 
#     echo "Database already exists"
# else
#     {
#         echo "FLUSH PRIVILEGES;"
#         echo "CREATE DATABASE IF NOT EXISTS $MDB_NAME;"
#         echo "CREATE USER IF NOT EXISTS $MDB_USER@'%' IDENTIFIED BY '$MDB_PASS';"
#         echo "GRANT ALL ON *.* TO $MDB_USER@'%' IDENTIFIED BY '$MDB_PASS';"
#         echo "FLUSH PRIVILEGES;"
#     } | mysqld --bootstrap
# fi

# echo "executing mysql daemon"
# exec mysqld_safe
# # using exec allows child processes to recieve the sigterm from docker stop,
# allowing for clean shutdowns