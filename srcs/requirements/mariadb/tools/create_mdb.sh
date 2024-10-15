#!/bin/bash

# Setup the /run/mysqld directory
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chmod 755 /run/mysqld

# Check if the database exists and create it if it doesn't
if [ ! -d "/var/lib/mysql/$MDB_NAME" ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql --skip-test-db --skip-name-resolve --auth-root-authentication-method=normal
    
    # Start MariaDB temporarily
    service mariadb start

    # Create the database and user
    mysql -e "
        CREATE DATABASE IF NOT EXISTS $MDB_NAME;
        CREATE USER IF NOT EXISTS '$MDB_USER'@'%' IDENTIFIED BY '$MDB_PASSWORD';
        GRANT ALL PRIVILEGES ON *.* TO '$MDB_USER'@'%';
        FLUSH PRIVILEGES;
    "

    # Stop MariaDB
    service mariadb stop
fi

echo "MariaDB is ready!"

# Switch to mysql user and start the server
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