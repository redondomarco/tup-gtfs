
select distinct cod_sms as stop_id
, c1.nombre || ' y ' || c2.nombre as stop_name , cod_sms as stop_code , punto_y as stop_lat, punto_x as stop_lon , 'OCHAVA ' || ochava as stop_desc
from "paradas4326" p 
inner join "calles" c1 on p.calle_uno = c1.id_calle inner join "calles" c2 on c2.id_calle = p.calle_dos
where punto_y <> 0 and punto_x <> 0
--(select min(gid) as id, cod_sms as stop_id, cod_sms as stop_name , cod_sms as stop_code from paradas4326
--group by cod_sms) a inner join
--(select min(paradas4326.gid) as id,   punto_x, punto_y, cod_sms, st_y(ST_ClosestPoint(tup4326.geom,paradas4326.geom)) as stop_lat, st_x(ST_ClosestPoint(tup4326.geom,paradas4326.geom)) as stop_lon  
--from paradas4326 inner join tup4326 on paradas4326.ramal = tup4326.id_ramal and paradas4326.sentido = left(tup4326.sentido,1)
--group by punto_x, punto_y, cod_sms, tup4326.geom, paradas4326.geom) b
--on a.id = b.id
--stop_name,stop_lat,stop_id,stop_lon,stop_code
--Maza Ja,-32.962714705,4667,-68.7911215033,M4667
--Maza Ja,-32.9604640164,4666,-68.7902862866,M4666
--Maza Ja,-32.9603936883,4665,-68.790406986,M4665
--Chiclana,-32.9629187122,4664,-68.7937409718,M4664
--Palacios,-32.9628883846,4663,-68.7937587118,M4663
--Palacios,-32.9610513007,4662,-68.7931015706,M4662
--Palacios,-32.9610695493,4661,-68.7932268469,M4661
--Palacios,-32.9587618937,4660,-68.7924761182,M4660
--Guiñazú 902,-33.0341793152,9043,-68.8826270177,M9043
