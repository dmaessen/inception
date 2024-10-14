#!/bin/bash

# Ensure necessary environment variables are set
: "${MDB_NAME:?Environment variable MDB_NAME is required}"
: "${MDB_USER:?Environment variable MDB_USER is required}"
: "${MDB_PASSWORD:?Environment variable MDB_PASSWORD is required}"
: "${MDB_ROOT_PASSWORD:?Environment variable MDB_ROOT_PASSWORD is required}"

# Create necessary directories with proper permissions
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chmod 755 /run/mysqld

# Start MariaDB
mysqld --user=mysql --datadir=/var/lib/mysql --skip-test-db --skip-name-resolve --auth-root-authentication-method=normal &

# Wait for the server to start
sleep 10

# Check if the database exists using a SQL query
if ! mysql -u root -p"$MDB_ROOT_PASSWORD" -e "USE $MDB_NAME"; then
    mysql -u root -p"$MDB_ROOT_PASSWORD" < EOF
        CREATE DATABASE $MDB_NAME;
        CREATE USER IF NOT EXISTS '$MDB_USER'@'%' IDENTIFIED BY '$MDB_PASSWORD';
        GRANT ALL PRIVILEGES ON $MDB_NAME.* TO '$MDB_USER'@'%';
        FLUSH PRIVILEGES;
    EOF
else
    echo "Database '$MDB_NAME' already exists."
fi

# Stop MariaDB gracefully
mysqladmin -u root -p"$MDB_ROOT_PASSWORD" shutdown

echo "MariaDB is ready!"
exec "$@"








# mkdir -p /run/mysqld
# chown -R mysql:mysql /run/mysqld
# chmod 755 /run/mysqld

# # checks if databases exisits and creates it if it doesn't
# if [ ! -d "/var/lib/mysql/$MDB_NAME" ]; then
#     # mariadb-install-db --user=mysql --datadir=/var/lib/mysl --skip-test-db --skip-name-resolve --auth-root-authentication-method=normal

#     # starts mariadb service temporarly to create the database and user
#     service mariadb start

#     # passes argument as string, grants full access (SELECT/INSERT/UPDATE/DEL..) on all databases/tables
#     mysql -e "
#         CREATE DATABASE IF NOT EXISTS $MDB_NAME;
#         CREATE USER IF NOT EXISTS '$MDB_USER'@'%' IDENTIFIED BY '$MDB_PASSWORD';
#         ALTER USER '$MDB_USER'@'%' IDENTIFIED BY '$MDB_PASSWORD';
#         GRANT ALL PRIVILEGES ON *.* TO '$MDB_USER'@'%' IDENTIFIED BY '$MDB_PASSWORD';
#         FLUSH PRIVILEGES;
#     "
#     service mariadb stop
#     # mysqladmin -u root -p$MDB_ROOT_PASSWORD shutdown

# fi

# echo "MariaDB is ready!";
# exec "$@"



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