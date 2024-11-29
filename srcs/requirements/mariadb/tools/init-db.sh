#!/bin/bash

# Load sensitive variables from secrets
DB_NAME=$(cat /run/secrets/db_name)
DB_USER=$(cat /run/secrets/db_user)
DB_ROOT_PASS=$(cat /run/secrets/db_root_pass)

# command initializes the MySQL system database, creating necessary files and structure
mysql_install_db
# start mysql daemon
mysqld
sleep 7