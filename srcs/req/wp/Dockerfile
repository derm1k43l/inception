FROM debian:bullseye

## Install PHP-FPM and required extensions
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y php7.4-fpm php7.4-mysqli curl mariadb-client

COPY www.conf /etc/php/7.4/fpm/pool.d/.
COPY install-wp.sh .

RUN chmod +x install-wp.sh

CMD [ "./install-wp.sh" ]