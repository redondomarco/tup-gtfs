select distinct tup4326.id_ramal as route_id, 
CASE WHEN left(route_name,3) in ('121','126','128','127')  THEN tup4326.id_ramal::varchar(50) || 'U'  ELSE tup4326.id_tup::varchar(50) END as trip_id, 
CASE WHEN left(route_name,3) in ('121','126','128','127')  THEN ramales.desclinea ELSE route_name  END as trip_headsign, 
'default' as service_id, 
tup4326.id_ramal as shape_id,
'' --CASE WHEN route_name like '%Vuelta' THEN 1 WHEN route_name like '%Ida' THEN 0 END 
as direction_id, 
CASE WHEN left(route_name,3) in ('121','126','128','127')  THEN tup4326.id_ramal::varchar(10)  ELSE '' END as block_id 
from "tup4326" tup4326 inner join "ramales" ramales on ramales.id_ramal= tup4326.id_ramal
--where sentido = 'IDA'
order by tup4326.id_ramal


-- route_id,trip_id,trip_headsign,service_id,shape_id,direction_id
--40,101.212.2069.3.19:53:00,Cadore Centro,3,2069,1
--25,072.140.2435.1.08:38:00,F S.Ign Colon Gob,1,2435,1
--48,122.231.2169.1.21:57:00,B La Glo-P.Olive,1,2169,1
--87,B26.162.2734.3.22:12:00,A Paraguay,3,2734,0
--35,088.281.2932.1.08:10:00,Shopping - Notti,1,2932,1
--5
