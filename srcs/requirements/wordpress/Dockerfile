FROM debian:bullseye

## Install PHP-FPM and required extensions
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y php7.4-fpm php7.4-mysqli curl mariadb-client

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/.
COPY ./conf/wp-install.sh .

RUN chmod +x wp-install.sh

CMD [ "./wp-install.sh" ]