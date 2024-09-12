#bash
today=$(date +"%Y%m%d-%H%M%S")
sh shape2psql.sh > actualizacion/shape2psql-${today}.log
sh psql2gtfs.sh > actualizacion/psql2gtfs-${today}.log

