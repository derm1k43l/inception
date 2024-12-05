FROM alpine:3.18
# install redis and bash (for debugging purposes)
# enter container with: docker exec -it "redis" bash
# check redis status with: redis-cli ping or set  key "asd" adn get key...
RUN apk add --no-cache redis bash

WORKDIR /var/www/html

EXPOSE 6379

# Start Redis server with default configuration
CMD ["redis-server", "--bind", "0.0.0.0", "--protected-mode", "no"]