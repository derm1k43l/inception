FROM nginx:alpine
COPY gen-page.sh /docker-entrypoint.d/gen-page.sh
RUN chmod +x /docker-entrypoint.d/gen-page.sh
EXPOSE 80
