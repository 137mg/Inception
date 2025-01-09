FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y mariadb-server nano

COPY ./tools/50-server.cnf /etc/mysql/mariadb.conf.d/

RUN chmod 644 /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./conf/mdb_conf.sh /mdb_conf.sh

RUN chmod +x /mdb_conf.sh

ENTRYPOINT ["./mdb_conf.sh"]
