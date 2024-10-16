# pulls the base image, the penultimate stable now is bullseye - debian 11
FROM debian:bullseye

# default port of mariadb, the container listens on that port and is open to other containers only not host
EXPOSE 3306

#ARG makes it available only during the image buidl process and cannot be accessed after the image is built
ENV MDB_HOST=${MDB_HOST}
ENV MDB_NAME=${MDB_NAME}
ENV MDB_USER=${MDB_USER}
ENV MDB_PASSWORD=${MDB_PASSWORD}
ENV MDB_ROOT_PASSWORD=${MDB_ROOT_PASSWORD}

RUN apt-get update && apt-get upgrade -y

# installs all required packages
RUN apt-get install -y mariadb-server mariadb-client
RUN apt-get update && apt-get install -y gosu

RUN mkdir -p /var/log/mysql /var/lib/mysql
RUN getent group mysql || groupadd -r mysql && \
    getent passwd mysql || useradd -r -g mysql mysql
RUN chown -R mysql:mysql /var/lib/mysql /var/log/mysql
RUN chmod 755 /var/lib/mysql /var/log/mysql

RUN mkdir -p /run/mysqld
RUN chown -R mysql:mysql /run/mysqld
RUN chmod 755 /run/mysqld

RUN rm -f /etc/mysql/my.cnf /etc/mysql/mariadb.cnf

# allows MySQL to accept connections from any IP address, making it accessible outside the container or host
RUN sed -i 's/bind-address\s*= 127.0.0.1/bind-address = 0.0.0.0/g' \
    /etc/mysql/mariadb.conf.d/50-server.cnf

# copies file from host to container
COPY ./tools/create_mdb.sh /create_mdb.sh
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
RUN chmod +x /create_mdb.sh

WORKDIR /var/lib/mysql

ENTRYPOINT ["/create_mdb.sh"]

CMD ["mysqld"]