# pulls the base image, the penultimate stable now is bullseye - debian 11
FROM debian:bullseye

# connection for PHP-FPM/Nginx
EXPOSE 9000
# default port for MySQL and mariadb database servers
EXPOSE 3306

# putting it at the root 
COPY ./tools/create_wp.sh /create_wp.sh 
RUN chmod +x /create_wp.sh

RUN apt-get update -y && apt-get upgrade -y

# installs all required packages
# curl: for HTTP requests
# netcat: is used to write/read network connections, and here to ping
#   the MariaDB container to make sure its running before wordpress container
RUN apt-get install -y curl php php7.4 php7.4-fpm php7.4-mysql php7.4-redis mariadb-client netcat

# wp-cli installation, phar (PHP archive) from its github dir
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# wp-cli permission
RUN chmod +x wp-cli.phar
RUN mv ./wp-cli.phar /usr/local/bin/wp
RUN mkdir -p /var/www/html
RUN chown -R www-data:www-data /var/www/html
# changes the cnf so that PHP-FPM listens on port 9000, making it possible for ngnix to communicate with PHP-FPM over the network
RUN sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/g' /etc/php/7.4/fpm/pool.d/www.conf

#COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# create the folder to enable php start
RUN mkdir -p /run/php

WORKDIR /var/www/html

ENTRYPOINT ["/create_wp.sh"]

CMD ["/usr/sbin/php-fpm7.4", "-F"]
