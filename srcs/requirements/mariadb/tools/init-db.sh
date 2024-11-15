#!/bin/sh

# Start MariaDB in background so that the database is ready
echo 1
service mariadb start
echo 2
sleep 5

# Initialize database and user
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "aaa"
	mysql_install_db --user=mysql --datadir=/var/lib/mysql
	echo "aa1a"
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
    mysql -u root -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';"
    mysql -u root -e "FLUSH PRIVILEGES;"
	echo "aaa2"
    service mariadb stop
	echo "aa3"
fi
echo 3
service mariadb start
echo 4

# Start MariaDB
exec /usr/sbin/mysqld --user=mysql
echo 5