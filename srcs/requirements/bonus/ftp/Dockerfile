FROM alpine:3.18
# Install vsftpd and create FTP user
RUN apk add --no-cache vsftpd \
    && mkdir -p /home/vsftpd/fptuser \
    && echo "Welcome to FTP server" > /home/vsftpd/fptuser/welcome.txt \
    && chown -R ftp:ftp /home/vsftpd/fptuser

COPY ./conf/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY ./conf/init-ftp.sh /init-ftp.sh
RUN chmod +x /init-ftp.sh
EXPOSE 20-21 21100-21110
CMD [ "sh", "/init-ftp.sh" ]