#bash

#export PGPASSWORD=
#export POSTGRES_USER=

today=$(date +"%Y%m%d-%H%M%S")

rm gtfs/calendar.txt
psql "host=pg_tup dbname=tup_gtfs user=${POSTGRES_USER}" -f gtfs-sql/calendar.sql --csv > gtfs/calendar.txt
rm gtfs/agency.txt
psql "host=pg_tup dbname=tup_gtfs user=${POSTGRES_USER}" -f gtfs-sql/agency.sql --csv > gtfs/agency.txt
rm gtfs/frequencies.txt
psql "host=pg_tup dbname=tup_gtfs user=${POSTGRES_USER}" -f gtfs-sql/frequencies.sql --csv > gtfs/frequencies.txt
rm gtfs/routes.txt
psql "host=pg_tup dbname=tup_gtfs user=${POSTGRES_USER}" -f gtfs-sql/routes.sql --csv > gtfs/routes.txt
rm gtfs/trips.txt
psql "host=pg_tup dbname=tup_gtfs user=${POSTGRES_USER}" -f gtfs-sql/trips.sql --csv > gtfs/trips.txt
rm gtfs/shapes.txt
psql "host=pg_tup dbname=tup_gtfs user=${POSTGRES_USER}" -f gtfs-sql/shapes.sql --csv > gtfs/shapes.txt
rm gtfs/stops.txt
psql "host=pg_tup dbname=tup_gtfs user=${POSTGRES_USER}" -f gtfs-sql/stops.sql --csv > gtfs/stops.txt
rm gtfs/stop_times.txt
psql "host=pg_tup dbname=tup_gtfs user=${POSTGRES_USER}" -f gtfs-sql/stop-times.sql --csv > gtfs/stop_times.txt

rm otp/gtfs.zip
zip -j otp/gtfs.zip gtfs/*.txt

rm /otp/*.pbf

python2 /libs/transitfeed-1.2.16/feedvalidator.py -n otp/gtfs.zip -o /logs/validation-result_${today}.html

# descargo mapa argentina
axel -n 10 --output=/tmp/argentina-latest.osm.pbf http://download.geofabrik.de/south-america/argentina-latest.osm.pbf

# recorto area rosario
# https://boundingbox.klokantech.com/
osmconvert /tmp/argentina-latest.osm.pbf -b=-60.931758,-33.044954,-60.611781,-32.813269 --complete-ways -o=/tmp/rosario-unfiltered.pbf
#-60.9382,-33.175,-60.4493,-32.7233
# filtro 1
osmosis --rb /tmp/rosario-unfiltered.pbf --tf reject-ways building=* --tf reject-ways waterway=* --tf reject-ways landuse=* --tf reject-ways natural=* --used-node --wb /tmp/rosario-filtered1.pbf

#filtro 2

osmium tags-filter /tmp/rosario-filtered1.pbf w/highway wa/public_transport=platform wa/railway=platform w/park_ride=yes r/type=restriction r/type=route -o /otp/rosario-filtered2.pbf -f pbf,add_metadata=false

/java-se-8u44-ri/bin/java -Xmx2G -jar /otp-1.2.0-shaded.jar --build otp/

#java -Xmx2G -jar /otp-2.4.0-shaded.jar --build --save otp/ > /logs/otp_${today}.log

#scp otp/Graph.obj tcatws1-test:/mnt/ubicaciones
# http://tcatws1-test.pm.rosario.gov.ar:8080/ubicaciones/graph-info
# https://t-comollego.rosario.gob.ar/
