# must set up your entire application (i.e., it has to build the Docker images using
# docker-compose.yml)

DOCKER_COMPOSE_FILE = ./srcs/docker-compose.yml
DOCKER_COMPOSE = docker-compose -f $(DOCKER_COMPOSE_FILE)

help:
	@echo "Usage: make [COMMAND]"
	@echo ""
	@echo "Commands:"
	@echo "  up           Start the Docker services"
	@echo "  down         Stop the Docker services"
	@echo "  stop         Stop the Docker services"
	@echo "  restart      Restart the Docker services"
	@echo "  build        Build the Docker images"
	@echo "  logs         View logs for all services"
	@echo "  list         Lists all containers"
	@echo "  list_vol     Lists all volumes"
	@echo "  clean        Remove containers and volumes"
	# @echo "  shell        Open a shell in the WordPress container"

all: build up

build:
	cp srcs/.env_example srcs/.env
	@mkdir -p /home/dmaessen/data
	@mkdir -p /home/dmaessen/data/db
	@mkdir -p /home/dmaessen/data/wp
	$(DOCKER_COMPOSE) build

up:
	$(DOCKER_COMPOSE) up --remove-orphans #-d

down:
	$(DOCKER_COMPOSE) down

stop:
	$(DOCKER_COMPOSE) stop

restart: stop build up

build:
	$(DOCKER_COMPOSE) build

logs:
	$(DOCKER_COMPOSE) logs -f

list:
	docker ps -a

list_vol:
	docker volume ls

exec-mariadb:
	docker exec -it mariadb bash

exec-wp:
	docker exec -it wordpress bash

exec-nginx:
	docker exec -it nginx bash

# removes all containers/volumes/images, --rmi all removes built images
clean:
	$(DOCKER_COMPOSE) down -v --rmi all


.PHONY: help, all, up, down, stop, restart, build, logs, list, list_volumes, clean, build