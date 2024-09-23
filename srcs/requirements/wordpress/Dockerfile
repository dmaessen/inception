# pulls the base image, the penultimate stable now is bullseye - debian 11
FROM debian: bullseye

RUN apt-get update

# says yes to everything
RUN apt-get upgrade -y

# installs all required packages
# curl: for HTTP requests
# netcat: is used to write/read network connections, and here to ping
#   the MariaDB container to make sure its running before wordpress container
RUN apt-get install -y curl php php7.4-pm php-mysql mariadb-client netcat

# copies the script within the root of the container
COPY ./tools/create_wp.sh /

RUN chmod +x create_wp.sh

ENTRYPOINT ["./create_wp.sh"]
