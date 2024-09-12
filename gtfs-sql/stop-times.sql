select * from ( 

select distinct 
--CASE WHEN paradas4326.sentido = 'I' THEN 0 ELSE 1 END + ST_LineLocatePoint(ST_LineMerge(b.geom),paradas4326.geom) as aux,
--orden_primero, orden_ultimo, 
row_number() over (partition by b.id_tup order by CASE WHEN paradas4326.sentido = 'I' THEN 0 ELSE 1 END + ST_LineLocatePoint(ST_LineMerge(b.geom),paradas4326.geom) asc) as stop_sequence, b.id_tup::varchar(50) as trip_id, 
CASE WHEN paradas4326.sentido = 'I' 
THEN (time '08:00:00' + (((c.longitud_ida*ST_LineLocatePoint(ST_LineMerge(b.geom),paradas4326.geom))/3.88) ::char(10) ||' seconds')::interval)::char(8) 
ELSE (time '08:00:00' + (((c.longitud_ida + c.longitud_vuelta*ST_LineLocatePoint(ST_LineMerge(b.geom),paradas4326.geom))/3.88)::char(10) ||' seconds')::interval)::char(8)  
END as arrival_time,

CASE WHEN paradas4326.sentido = 'I' 
THEN (time '08:00:00' + (((c.longitud_ida*ST_LineLocatePoint(ST_LineMerge(b.geom),paradas4326.geom))/3.88) ::char(10) ||' seconds')::interval)::char(8) 
ELSE (time '08:00:00' + (((c.longitud_ida + c.longitud_vuelta*ST_LineLocatePoint(ST_LineMerge(b.geom),paradas4326.geom))/3.88)::char(10) ||' seconds')::interval)::char(8)  
END as departure_time,

--CASE WHEN (CASE WHEN paradas4326.sentido = 'I' THEN 0 ELSE 1 END +ST_LineLocatePoint(ST_LineMerge(b.geom),paradas4326.geom) = orden_primero) 
--THEN (time '08:00:00' + (((c.longitud_ida*ST_LineLocatePoint(ST_LineMerge(b.geom),paradas4326.geom))/3.5) ::char(10) ||' seconds')::interval)::char(8) 
--WHEN orden_ultimo = CASE WHEN paradas4326.sentido = 'I' THEN 0 ELSE 1 END +ST_LineLocatePoint(ST_LineMerge(b.geom),paradas4326.geom) 
--THEN (time '08:00:00' + (((c.longitud_ida + c.longitud_vuelta*ST_LineLocatePoint(ST_LineMerge(b.geom),paradas4326.geom))/3.5)::char(10) ||' seconds')::interval)::char(8) ELSE '' END 
-- as arrival_time, 
--CASE WHEN (CASE WHEN paradas4326.sentido = 'I' THEN 0 ELSE 1 END +ST_LineLocatePoint(ST_LineMerge(b.geom),paradas4326.geom) = orden_primero) 
--THEN (time '08:00:00' + (((c.longitud_ida*ST_LineLocatePoint(ST_LineMerge(b.geom),paradas4326.geom))/3.5)::char(10) ||' seconds')::interval)::char(8) 
--WHEN orden_ultimo = CASE WHEN paradas4326.sentido = 'I' THEN 0 ELSE 1 END +ST_LineLocatePoint(ST_LineMerge(b.geom),paradas4326.geom) 
--THEN (time '08:00:00' + (((c.longitud_ida + c.longitud_vuelta*ST_LineLocatePoint(ST_LineMerge(b.geom),paradas4326.geom))/3.5)::char(10) ||' seconds')::interval)::char(8) ELSE '' END 
-- as departure_time,
cod_sms as stop_id, CASE WHEN paradas4326.sentido = 'I' THEN fin_ida ELSE fin_vuelta END as stop_headsign, '' as pickup_type, '' as drop_off_type, '' as shape_dist_traveled
--, ST_LineLocatePoint(ST_LineMerge(b.geom),paradas4326.geom)
from (
select t.id_ramal, t.id_tup, tupgeom, t.geom, ramal, paradas4326.sentido, min(CASE WHEN paradas4326.sentido = 'I' THEN 0 ELSE 999999 END + ST_LineLocatePoint(ST_LineMerge(t.geom),paradas4326.geom)) as orden_primero, max(CASE WHEN paradas4326.sentido = 'V' THEN 1 ELSE -9999999 END + ST_LineLocatePoint(ST_LineMerge(t.geom),paradas4326.geom)) as orden_ultimo
from "paradas4326" paradas4326 inner join "tup4326" as tup4326 on paradas4326.ramal = tup4326.id_ramal and paradas4326.sentido = left(tup4326.sentido,1)
inner join (select id_ramal, id_tup, st_transform(ST_SetSRID(tup4326.geom,4326),22185) as tupgeom, geom from "tup4326" tup4326) t on t.id_tup = tup4326.id_tup
--where orden >= 0 
and st_distance(tupgeom, st_transform(ST_SetSRID(paradas4326.geom,4326),22185)) < 50
group by t.id_ramal, t.id_tup, tupgeom, t.geom, ramal, paradas4326.sentido
) b 
inner join "ramales" ral on ral.id_ramal = b.id_ramal
inner join (select distinct parada,ramal,sentido, cod_sms, geom from "paradas4326" paradas4326) as paradas4326 on paradas4326.ramal = b.ramal and paradas4326.sentido = b.sentido 
inner join (select * from v_tup_x_linea ) c on b.ramal = c.id_ramal
where left(ral.desclinea,3) not in ('121','126','128','127')  
and st_distance(tupgeom, st_transform(ST_SetSRID(paradas4326.geom,4326),22185)) < 50

UNION ALL

select distinct 
--CASE WHEN paradas4326.sentido = 'I' THEN 0 ELSE 1 END + ST_LineLocatePoint(ST_LineMerge(b.geom),paradas4326.geom) as aux,
--orden_primero, orden_ultimo, 
row_number() over (partition by b.id_ramal order by CASE WHEN paradas4326.sentido = 'I' THEN 0 ELSE 1 END + ST_LineLocatePoint(ST_LineMerge(b.geom),paradas4326.geom) asc) as stop_sequence, b.id_ramal::varchar(50) || 'U' as trip_id, 
CASE WHEN paradas4326.sentido = 'I' 
THEN (time '08:00:00' + (((c.longitud_ida*ST_LineLocatePoint(ST_LineMerge(b.geom),paradas4326.geom))/3.88) ::char(10) ||' seconds')::interval)::char(8) 
ELSE (time '08:00:00' + (((c.longitud_ida + c.longitud_vuelta*ST_LineLocatePoint(ST_LineMerge(b.geom),paradas4326.geom))/3.88)::char(10) ||' seconds')::interval)::char(8)  
END as arrival_time,

CASE WHEN paradas4326.sentido = 'I' 
THEN (time '08:00:00' + (((c.longitud_ida*ST_LineLocatePoint(ST_LineMerge(b.geom),paradas4326.geom))/3.88) ::char(10) ||' seconds')::interval)::char(8) 
ELSE (time '08:00:00' + (((c.longitud_ida + c.longitud_vuelta*ST_LineLocatePoint(ST_LineMerge(b.geom),paradas4326.geom))/3.88)::char(10) ||' seconds')::interval)::char(8)  
END as departure_time,

--CASE WHEN (CASE WHEN paradas4326.sentido = 'I' THEN 0 ELSE 1 END +ST_LineLocatePoint(ST_LineMerge(b.geom),paradas4326.geom) = orden_primero) 
--THEN (time '08:00:00' + (((c.longitud_ida*ST_LineLocatePoint(ST_LineMerge(b.geom),paradas4326.geom))/3.5) ::char(10) ||' seconds')::interval)::char(8) 
--WHEN orden_ultimo = CASE WHEN paradas4326.sentido = 'I' THEN 0 ELSE 1 END +ST_LineLocatePoint(ST_LineMerge(b.geom),paradas4326.geom) 
--THEN (time '08:00:00' + (((c.longitud_ida + c.longitud_vuelta*ST_LineLocatePoint(ST_LineMerge(b.geom),paradas4326.geom))/3.5)::char(10) ||' seconds')::interval)::char(8) ELSE '' END 
-- as arrival_time, 
--CASE WHEN (CASE WHEN paradas4326.sentido = 'I' THEN 0 ELSE 1 END +ST_LineLocatePoint(ST_LineMerge(b.geom),paradas4326.geom) = orden_primero) 
--THEN (time '08:00:00' + (((c.longitud_ida*ST_LineLocatePoint(ST_LineMerge(b.geom),paradas4326.geom))/3.5)::char(10) ||' seconds')::interval)::char(8) 
--WHEN orden_ultimo = CASE WHEN paradas4326.sentido = 'I' THEN 0 ELSE 1 END +ST_LineLocatePoint(ST_LineMerge(b.geom),paradas4326.geom) 
--THEN (time '08:00:00' + (((c.longitud_ida + c.longitud_vuelta*ST_LineLocatePoint(ST_LineMerge(b.geom),paradas4326.geom))/3.5)::char(10) ||' seconds')::interval)::char(8) ELSE '' END 
-- as departure_time,
cod_sms as stop_id, CASE WHEN paradas4326.sentido = 'I' THEN fin_ida ELSE fin_vuelta END as stop_headsign, '' as pickup_type, '' as drop_off_type, '' as shape_dist_traveled
--, ST_LineLocatePoint(ST_LineMerge(b.geom),paradas4326.geom)
from (
select t.id_ramal, t.id_tup, tupgeom, t.geom, ramal, paradas4326.sentido, min(CASE WHEN paradas4326.sentido = 'I' THEN 0 ELSE 999999 END + ST_LineLocatePoint(ST_LineMerge(t.geom),paradas4326.geom)) as orden_primero, max(CASE WHEN paradas4326.sentido = 'V' THEN 1 ELSE -9999999 END + ST_LineLocatePoint(ST_LineMerge(t.geom),paradas4326.geom)) as orden_ultimo
from "paradas4326" paradas4326 inner join "tup4326" as tup4326 on paradas4326.ramal = tup4326.id_ramal and paradas4326.sentido = left(tup4326.sentido,1)
inner join (select id_ramal, id_tup, st_transform(ST_SetSRID(tup4326.geom,4326),22185) as tupgeom, geom from "tup4326" tup4326) t on t.id_tup = tup4326.id_tup
--where orden >= 0 
and st_distance(tupgeom, st_transform(ST_SetSRID(paradas4326.geom,4326),22185)) < 50
group by t.id_ramal, t.id_tup, tupgeom, t.geom, ramal, paradas4326.sentido
) b 
inner join "ramales" ral on ral.id_ramal = b.id_ramal
inner join (select distinct parada,ramal,sentido, cod_sms, geom from "paradas4326" paradas4326) as paradas4326 on paradas4326.ramal = b.ramal and paradas4326.sentido = b.sentido 
inner join (select * from v_tup_x_linea ) c on b.ramal = c.id_ramal
where left(ral.desclinea,3) in ('121','126','128','127')  
and st_distance(tupgeom, st_transform(ST_SetSRID(paradas4326.geom,4326),22185)) < 50

) stop_times
order by trip_id, stop_sequence
