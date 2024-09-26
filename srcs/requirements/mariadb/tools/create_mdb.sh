#!/bin/bash

# checks if databases exisits and creates it if it doesn't
if [ ! -d "/var/lib/mysql/$MDB_NAME" ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysl --skip-test-db --skip-name-resolve --auth-root-authentication-method=normal

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

fi

echo "MariaDB is ready!";
exec "$@"