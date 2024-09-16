#bash
today=$(date +"%Y%m%d-%H%M%S")
sh shape2psql.sh > /logs/shape2psql-${today}.log
sh psql2gtfs.sh > /logs/psql2gtfs-${today}.log
chmod 777 /logs
echo ''
echo 'generado..'
ls -la /otp/Graph.obj

echo 'validacion en'
ls -lart /logs/validation-*

echo 'logs en'
ls -lart /logs/*.log