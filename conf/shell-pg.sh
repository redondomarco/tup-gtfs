#!/bin/bash
dockerid=`docker ps | grep db_tup | cut -f1 -d' '`
echo id docker $dockerid
docker exec -t -i $dockerid bash
exit 0