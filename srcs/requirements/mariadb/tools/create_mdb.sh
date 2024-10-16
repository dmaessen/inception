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