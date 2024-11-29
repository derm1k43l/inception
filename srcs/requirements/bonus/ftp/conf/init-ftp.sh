#!/bin/sh

# Add FTP user (hardcoded for simplicity)
adduser -D -h /home/vsftpd/42test -s /sbin/nologin 42test
echo "42test:42test" | chpasswd

# Start vsftpd
vsftpd /etc/vsftpd/vsftpd.conf