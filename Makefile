NAME =./srcs/docker-compose.yml
WORDPRESS_DATA = $(HOME)/data/wordpress/
MARIADB_DATA = $(HOME)/data/mariadb/

# Default target
all: creat_dirs start_containers #hosts

# in vm only
#hosts:
#	@echo "Adding hosts to /etc/hosts file...\n"
#	@echo 127.0.0.1 mrusu.42.fr >> /etc/hosts"

creat_dirs:
	@echo "Creating directories if they don't exist...\n"
	mkdir -p $(WORDPRESS_DATA) $(MARIADB_DATA)
	chmod -R 777 $(WORDPRESS_DATA) $(MARIADB_DATA)

start_containers:
	@echo "Starting the containers...\n"
	@export COMPOSE_HTTP_TIMEOUT=200 && docker-compose -f $(NAME) up --build -d

# Stop and remove containers (keep volumes)
down:
	@echo "Stopping the containers...\n"
	@docker-compose -f $(NAME) down

 # Stop and remove containers, volumes network images
fclean: down
	@echo "Removing containers, volumes, network and images...\n"
	@docker-compose -f $(NAME) down --volumes --rmi all
	@rm -rf $(WORDPRESS_DATA) $(MARIADB_DATA)
	@docker volume prune -f
	@docker network prune -f
	@docker system prune -af

# Show the status of the containers
ps:
	@docker-compose -f $(NAME) ps

# Logs for containers .. -f to follow the logs we can interrupt with ctrl+c or remove -f
logs_wp:
	@echo "Fetching logs for WordPress container..."
	@docker-compose -f $(NAME) logs -f --tail 50 wordpress

logs_db:
	@echo "Fetching logs for MariaDB container..."
	@docker-compose -f $(NAME) logs -f --tail 50 mariadb

logs_nx:
	@echo "Fetching logs for Nginx container..."
	@docker-compose -f $(NAME) logs -f --tail 50 nginx

re: fclean all

.PHONY: all clean fclean re ps logs logs_wp logs_db logs_nx creat_dirs start_containers
