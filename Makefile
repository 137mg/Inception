FILE_PATH = ./srcs/docker-compose.yml
WP_DATA = /home/mgoedkoo/data/wordpress
DB_DATA = /home/mgoedkoo/data/mariadb

all: up

up: build
	mkdir -p $(WP_DATA)
	mkdir -p $(DB_DATA)
	docker compose -f $(FILE_PATH) up -d

build:
	docker compose -f $(FILE_PATH) build

start:
	docker compose -f $(FILE_PATH) start

stop:
	docker compose -f $(FILE_PATH) stop

down:
	docker compose -f $(FILE_PATH) down -v --rmi all

clean: down
	rm -rf $(WP_DATA)
	rm -rf $(DB_DATA)

re: clean up
