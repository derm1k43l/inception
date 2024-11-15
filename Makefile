NAME =./srcs/docker-compose.yml
WORDPRESS_DATA = /Users/${USER}/Desktop/asd/wordpress1
MARIADB_DATA = /Users/${USER}/Desktop/asd/mariadb1

# Default target
all:
	@echo "Creating directories if they don't exist... \n"
	mkdir -p $(WORDPRESS_DATA) $(MARIADB_DATA)
	chmod -R 777 $(WORDPRESS_DATA) $(MARIADB_DATA)
	@echo "Starting the containers... \n"
	@export COMPOSE_HTTP_TIMEOUT=200 && docker-compose -f $(NAME) up --build -d

# Stop and remove containers (keep volumes)
clean:
	@echo "Stopping the containers... \n"
	@docker-compose -f $(NAME) down

 # Stop and remove containers, volumes network images
fclean: clean
	@echo "Removing containers, volumes, network and images... \n"
	@docker-compose -f $(NAME) down --volumes --rmi all
	@rm -rf $(WORDPRESS_DATA) $(MARIADB_DATA)

ps:
	@docker-compose -f $(NAME) ps

logs:
	@docker-compose -f $(NAME) logs --verbose

re: fclean all

.PHONY: all clean fclean re ps logs
