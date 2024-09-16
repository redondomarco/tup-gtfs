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

python2 /libs/transitfeed-1.2.16/feedvalidator.py -n otp/gtfs.zip -o /logs/validation-result_${today}.html

/java-se-8u44-ri/bin/java -Xmx2G -jar /otp-1.2.0-shaded.jar --build otp/

#scp otp/Graph.obj tcatws1-test:/mnt/ubicaciones
