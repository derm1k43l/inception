FROM debian:bookworm

# Install MariaDB
RUN apt-get update && apt-get upgrade -y && \
    apt-get install mariadb-server -y && \
    apt clean

# Expose MariaDB port
EXPOSE 3306

# Run the init script as the container's main process
CMD ["mysqld"]