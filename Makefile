include .env
RUN = docker-compose run --no-deps --rm -u root web2py

start:
	@docker-compose up -d
stop:
	@docker-compose down

restart: stop start

logs:
	@docker-compose logs


shell:
	./conf/shell-pg.sh

build:
	docker build -t postgis-tup:0.1 .

ps:
	docker ps

rebuild: stop build start ps shell

