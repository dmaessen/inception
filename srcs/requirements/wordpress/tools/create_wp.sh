#!/bin/bash
#---------------------------------------------------wp installation---------------------------------------------------#
# wp-cli installation, phar (PHP archive) from its github dir
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# wp-cli permission
chmod +x wp-cli.pahr
mv wp-cli.par /usr/local/bin/wp

cd /var/www/wordpress
# give permissions to read/write/execute to wp dir
chmod -R 755 /var/wwww/wordpress/
# change owner of wp dir to wwww-data user (used by web server nginx)
chown -R wwww-data:wwww-data /var/wwww/wordpress

#---------------------------------------------------mariadb---------------------------------------------------#
# check if mariadb container is up and running, trying to connect to its port
ping_mariadb_container() {
    # netcat scans via the port to see if connection with mariadb database is open
    # port 3306 which is the default for the MySQL and mariadb database servers
    # /dev/null meaning no output will be showed on stdout unless an error
    nc -zv mariadb 3306 > /dev/null
    return $? # exit status of ping
}
start_time=$(date +%s) # current time in seconds
end_time=$((start_time + 20)) # adds 20 sec to start time
while [$(date + $s) -lt $end_time]; do # loops until current time bigger than end (-lt = less than, it compares)
    ping_mariadb_container
    if [$? -eq 0]; then # check if ping succesful
        echo "[---- MARIADB IS UP AND RUNNING ----]"
        break
    else
        echo "[----- WAITING FOR MARIADB -----]"
        sleep 1 # tries again after 1sec
    fi
done

if [$(date + $s) -ge $end_time]; then # checks if current time is greater or equal to end
    echo "[---- NO RESPONSE FROM MARIADB ----]"
fi

#---------------------------------------------------wp---------------------------------------------------#
# downloads wordpress core files
wp core download --allow-root
# creates wp-config.php file with the database details
wp core config --dbhost=mariadb:3306 --dbname="$MDB_NAME" --dbuser="$MDB_USER" --dbpass="$MDB_PASSWORD" --allow-root
wp core install --url="$DOMAIN_NAME" --title="$WP_TITLE" --admin_user="$WP_ADMIN_USER" --admin_password="$WP_ADMIN_PASSWORD" --admin_email="$WP_ADMIN_MAIL" --allow-root
# create a new user with the below details
wp user create "$WP_USER" "$WP_USER_MAIL" --user_pass="$WP_USER_PASSWORD" --allow-root

#---------------------------------------------------php---------------------------------------------------#
# php optimizes perf, security and functionality of your web application
# change listen port from unix socket to 9000
# sed = stream editor; i will edit the file; on line 36; s will substitute s@old@new@; at location (here: /etc/...)
sed -i '36 s@/run/php/php7.4-fpm.sock@9000@' /etc/php/7.4/fpm/pool.d/www.conf
# create a directory for php-fpm
mkdir -p /run/php
# start php-fpm service in the foreground to keep the container running
/usr/sbin/php-fpm7.4 -F