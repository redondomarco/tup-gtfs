#
ogr2ogr -t_srs EPSG:22185 actualizacion/tup_proj.shp actualizacion/Recorridos/*.shp

ogr2ogr -t_srs EPSG:22185 actualizacion/paradas_proj.shp actualizacion/Paradas/*.shp

# borro tablas y archivos previos
psql "host=pg_tup dbname=tup_gtfs user=${POSTGRES_USER}" -c "truncate table tup4326;"

psql "host=pg_tup dbname=tup_gtfs user=${POSTGRES_USER}" -c "truncate table paradas4326;"

rm actualizacion/paradas4326.sql

rm actualizacion/tup4326.sql


#convierto a sql
shp2pgsql -a -W "latin1" actualizacion/Paradas/*.shp paradas4326 > actualizacion/paradas4326.sql

shp2pgsql -a -W "latin1" actualizacion/Recorridos/*.shp tup4326 > actualizacion/tup4326.sql

# inserto nuevos datos
psql "host=pg_tup dbname=tup_gtfs user=${POSTGRES_USER}" -f actualizacion/tup4326.sql

psql "host=pg_tup dbname=tup_gtfs user=${POSTGRES_USER}" -f actualizacion/paradas4326.sql
