# pulls the base image, the penultimate stable now is bullseye - debian 11
FROM debian:bullseye

# defualt port of mariadb, the container listens on that port and is open to other containers only not host
EXPOSE 3306

#ARG makes it available only during the image buidl process and cannot be accessed after the image is built
ARG MDB_HOST=${MDB_HOST}
ARG MDB_NAME=${MDB_NAME}
ARG MDB_USER=${MDB_USER}
ARG MDB_PASSWORD=${MDB_PASSWORD}
ARG MDB_ROOT_PASSWORD=${MDB_ROOT_PASSWORD}

RUN apt-get update && apt-get upgrade -y

# installs all required packages
RUN apt-get install -y mariadb-server mariadb-client

RUN mkdir -p /var/log/mysql
# or to /var/log/mysql ??
RUN chown -R mysql:mysql /var/lib/mysql

# RUN touch /var/log/mysql/error.log
# RUN chown -R mysql:mysql /var/log/mysql/error.log
# RUN chmod 777 /var/log/mysql/error.log

# allows MySQL to accept connections from any IP address, making it accessible outside the container or host
RUN sed -i 's/bind-address            = 127.0.0.1/bind-address            = 0.0.0.0/g' \
/etc/mysql/mariadb.conf.d/50-server.cnf

# copies file from host to container
COPY ./tools/create_mdb.sh /create_mdb.sh
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
RUN chmod +x /create_mdb.sh

WORKDIR /var/lib/mysql

ENTRYPOINT ["/create_mdb.sh"]

CMD ["mysqld_safe"]