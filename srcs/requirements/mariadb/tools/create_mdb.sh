#!/bin/bash

# checks if databases exisits and creates it if it doesn't
if [ ! -d "/var/lib/mysql/$MDB_NAME" ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql --skip-test-db --skip-name-resolve --auth-root-authentication-method=normal

    # starts mariadb service temporarly to create the database and user
    service mariadb start

    # passes argument as string, grants full access (SELECT/INSERT/UPDATE/DEL..) on all databases/tables
    mysql -e "
        CREATE DATABASE IF NOT EXISTS $MDB_NAME;
        CREATE USER IF NOT EXISTS '$MDB_USER'@'%' IDENTIFIED BY '$MDB_PASSWORD';
        ALTER USER '$MDB_USER'@'%' IDENTIFIED BY '$MDB_PASSWORD';
        GRANT ALL PRIVILEGES ON *.* TO '$MDB_USER'@'%' IDENTIFIED BY '$MDB_PASSWORD';
        FLUSH PRIVILEGES;
    "
    service mariadb stop
    # mysqladmin -u root -p$MDB_ROOT_PASSWORD shutdown

fi

echo "MariaDB is ready!";
exec "$@"



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