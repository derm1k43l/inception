NAME =./srcs/docker-compose.yml
WORDPRESS_DATA = $(HOME)/data/wordpress1/
MARIADB_DATA = $(HOME)/data/mariadb1/

# Increase the timeout for the docker-compose command
export mak=200

# Default target
all: creat_dirs start_containers #hosts

# in vm only
#hosts:
#	@echo "Adding hosts to /etc/hosts file...\n"
#	@echo 127.0.0.1 mrusu.42.fr >> /etc/hosts"

bonus: create_bonus_dir start_bonus_services

start_bonus_services:
	@echo "Starting the containers...\n"
	@docker-compose -f $(NAME) up --build -d redis ftp website adminer email

create_bonus_dir:
	@echo "Creating directories if they don't exist...\n"
	mkdir -p $(HOME)/data/redis
	mkdir -p $(HOME)/data/ftp
	mkdir -p $(HOME)/data/website
	mkdir -p $(HOME)/data/adminer

creat_dirs:
	@echo "Creating directories if they don't exist...\n"
	mkdir -p $(WORDPRESS_DATA) $(MARIADB_DATA)
	chmod -R 777 $(WORDPRESS_DATA) $(MARIADB_DATA)

start_containers:
	@echo "Starting the containers...\n"
	@docker-compose -f $(NAME) up --build -d nginx wordpress mariadb

# Stop and remove containers (keep volumes)
down:
	@echo "Stopping the containers...\n"
	@docker-compose -f $(NAME) down

 # Stop and remove containers, volumes network images
fclean: down
	@echo "Removing containers, volumes, network and images...\n"
	@docker-compose -f $(NAME) down --volumes --rmi all 
	@rm -rf $(WORDPRESS_DATA) $(MARIADB_DATA)
	@rm -rf $(HOME)/data/redis $(HOME)/data/ftp $(HOME)/data/website $(HOME)/data/adminer
	@docker volume prune -f
	@docker network prune -f
	@docker system prune -af

re: fclean all

# Show the status of the containers
ps:
	@docker-compose -f $(NAME) ps

# Logs for containers .. logs -f --tail 50 wordpress  to follow the logs we can interrupt with ctrl+c or remove -f
logs_wp:
	@echo "Fetching logs for WordPress container..."
	@docker-compose -f $(NAME) logs wordpress

logs_db:
	@echo "Fetching logs for MariaDB container..."
	@docker-compose -f $(NAME) logs mariadb

logs_nx:
	@echo "Fetching logs for Nginx container..."
	@docker-compose -f $(NAME) logs nginx

logs_rd:
	@echo "Fetching logs for Redis container..."
	@docker-compose -f $(NAME) logs redis

logs_ad:
	@echo "Fetching logs for Adminer container..."
	@docker-compose -f $(NAME) logs adminer

logs_wb:
	@echo "Fetching logs for Website container..."
	@docker-compose -f $(NAME) logs website

logs_ft:
	@echo "Fetching logs for FTP container..."
	@docker-compose -f $(NAME) logs ftp

.PHONY: all clean fclean re ps logs logs_wp logs_db logs_nx creat_dirs start_containers logs_rd logs_ad logs_wb logs_ft bonus create_bonus_dir start_bonus_services fclean_bonus
