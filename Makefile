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

#para desarrollo
rebuild: stop build start ps shell


check:
	docker run --rm -v ./otp:/work ghcr.io/mobilitydata/gtfs-validator:latest -i /work/gtfs.zip -o /work/output

generar-gtfs:
	conf/run-generar-gtfs.sh

#corre el proceso y lo chequea

run: start generar-gtfs check