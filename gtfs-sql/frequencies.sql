select distinct CASE WHEN left(route_name,3) in ('121','126','128','127')  THEN tup4326.id_ramal::varchar(50) || 'U'  ELSE tup4326.id_tup::varchar(50) END  as trip_id, '00:01:00' as start_time,'23:59:00' as end_time, 1 as headway_secs
from "tup4326" as tup4326 inner join "ramales" as ramales on tup4326.id_ramal = ramales.id_ramal 
--where sentido = 'IDA'