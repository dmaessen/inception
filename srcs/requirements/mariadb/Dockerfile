# pulls the base image, the penultimate stable now is bullseye - debian 11
FROM debian: bullseye

# defualt port of mariadb, the container listens on that port and is open to other containers only not host
EXPOSE 3306

ARG MDB_HOST=${MDB_HOST}
ARG MDB_NAME=${MDB_NAME}
ARG MDB_USER=${MDB_USER}
ARG MDB_PASSWORD=${MDB_PASSWORD}
ARG MDB_ROOT_PASSWORD=${MDB_ROOT_PASSWORD}

RUN apt-get update

# says yes to everything
RUN apt-get upgrade -y

# installs all required packages
RUN apt-get install -y mariadb-server

# copies file from host to container
COPY ./tools/create_mdb.sh /create_mdb.sh
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

RUN chmod +x /create_mdb.sh

ENTRYPOINT ["./create_mdb.sh"]