# must set up your entire application (i.e., it has to build the Docker images using
# docker-compose.yml)

DOCKER_COMPOSE_FILE = ./srcs/docker-compose.yml
DOCKER_COMPOSE = docker-compose -f $(DOCKER_COMPOSE_FILE)

help:
	@echo "Usage: make [COMMAND]"
	@echo ""
	@echo "Commands:"
	@echo "  all          Sets up the project"
	@echo "  build        Builds the containers"
	@echo "  up           Start the Docker services"
	@echo "  down         Stop the Docker services"
	@echo "  stop         Stop the Docker services"
	@echo "  restart      Restart the Docker services"
	@echo "  build        Build the Docker images"
	@echo "  logs         View logs for all services"
	@echo "  list         Lists all containers"
	@echo "  list_vol     Lists all volumes"
	@echo "  clean        Remove containers and volumes"

all: build up

build:
	@mkdir -p /home/dmaessen/data
	@mkdir -p /home/dmaessen/data/db
	@mkdir -p /home/dmaessen/data/wp
	@echo $(DOCKER_COMPOSE)
	$(DOCKER_COMPOSE) build

up:
	$(DOCKER_COMPOSE) up --remove-orphans #-d

down:
	$(DOCKER_COMPOSE) down

stop:
	$(DOCKER_COMPOSE) stop

restart: stop build up

logs:
	$(DOCKER_COMPOSE) logs -f

list:
	docker ps -a

list_vol:
	docker volume ls

certif:
	openssl x509 -in /etc/ssl/certs/ca-certificates.crt -text --noout

protocol:
	curl -v --tlsv1.3 https://dmaessen.42.fr

exec-mariadb:
	docker exec -it mariadb bash

exec-wp:
	docker exec -it wordpress bash

exec-nginx:
	docker exec -it nginx bash

# removes all containers/volumes/images, --rmi all removes built images
clean:
	$(DOCKER_COMPOSE) down -v --rmi all


.PHONY: help, all, up, down, stop, restart, build, logs, list, list_vol, clean, certif, protocol