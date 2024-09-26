# must set up your entire application (i.e., it has to build the Docker images using
# docker-compose.yml)

DOCKER_COMPOSE_FILE = docker-compose.yml
DOCKER_COMPOSE = docker-compose -f $(DOCKER_COMPOSE_FILE)

help:
	@echo "Usage: make [COMMAND]"
	@echo ""
	@echo "Commands:"
	@echo "  up           Start the Docker services"
	@echo "  down         Stop the Docker services"
	@echo "  restart      Restart the Docker services"
	@echo "  build        Build the Docker images"
	@echo "  logs         View logs for all services"
	# @echo "  nginx-logs   View Nginx logs"
	# @echo "  db-logs      View MariaDB logs"
	# @echo "  wp-logs      View WordPress logs"
	@echo "  clean        Remove containers and volumes"
	# @echo "  shell        Open a shell in the WordPress container"

up:
	$(DOCKER_COMPOSE) up -d

down:
	$(DOCKER_COMPOSE) down

restart:
	$(DOCKER_COMPOSE) down
	$(DOCKER_COMPOSE) up -d

build:
	$(DOCKER COMPOSE) build

logs:
	$(DOCKER_COMPOSE) logs -f

# removes all containers/volumes/images, --rmi all removes built images
clean:
	$(DOCKER_COMPOSE) down -v --rmi all


.PHONY: help, up, down, restart, build, logs, clean