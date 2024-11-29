FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server

COPY ./tools/50-server.cnf /etc/mysql/mariadb.conf.d/.
COPY ./tools/init.sql /etc/mysql/.
COPY ./tools/init-db.sh /init-db.sh

RUN mkdir /run/mysqld && chmod +x /init-db.sh

CMD [ "/init-db.sh" ]