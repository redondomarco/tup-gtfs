#!/bin/bash
dockerid=`docker ps | grep db_tup | cut -f1 -d' '`
echo id docker $dockerid
docker exec -t -i $dockerid sh generar-gtfs.sh
exit 0