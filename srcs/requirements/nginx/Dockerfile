FROM debian:bookworm

RUN apt update && apt upgrade -y && \
    apt install -y nginx openssl && \
    apt clean

# Generate SSL certificate
#  self-signed certificate and key with a 2048 bit RSA key 
#  and sha256 signature valid for 365 days
# save the privat key in /etc/nginx/ssl/nginx.key
# save the certificate in /etc/nginx/ssl/nginx.crt
# auto fill the certificate information to skip the prompt
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=FR/ST=Paris/L=Paris/O=42/OU=42/CN=localhost"

COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]