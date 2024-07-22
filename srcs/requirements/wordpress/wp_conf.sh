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

#---------------------------------------------------ping mariadb---------------------------------------------------#
# check if mariadb container is up and running, trying to connect to its port
ping_mariadb_container() {

}