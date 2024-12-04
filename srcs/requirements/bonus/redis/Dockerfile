FROM alpine:3.18
RUN apk add --no-cache redis
WORKDIR /data
EXPOSE 6379
CMD ["redis-server", "--bind", "0.0.0.0"]

