FROM debian:bookworm

RUN apt update && apt upgrade && \
    apt install -y php php8.2-fpm php-gd wget \
	php-mysql && apt clean

WORKDIR /var/www/html

# Download and extract wordpress
# 6.6.2 is the latest version that is compatible with php 8.2
# extract the wp tarball and move the content to the current directory
# remove the tarball and the extracted directory

RUN wget https://wordpress.org/wordpress-6.6.2.tar.gz && \
	tar -xzf wordpress-6.6.2.tar.gz && \
	mv wordpress/* . && \
	rm -rf wordpress wordpress-6.6.2.tar.gz

# Expose port php-fpm
EXPOSE 9000

# start php-fpm in foreground
CMD ["php-fpm", "-F"]
