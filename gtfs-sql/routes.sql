select distinct 
--ramales.desclinea as route_short_name ,
-- left(route_name, length(route_name) - 7) as route_short_name, 
COALESCE(tupcodsms.nombre_corto, ramales.desclinea) as route_short_name,
tup4326.id_ramal as route_id,
 3 as route_type, ramales.empresa as agency_id, 
 --left(route_name, length(route_name) - 7) as route_long_name,
 ramales.linea || CASE ramales.ramal WHEN 'UNICO' THEN '' ELSE ' ' || ramales.ramal END as route_long_name,
 CASE WHEN ramal like 'ROJ%' THEN 'red' WHEN ramal like 'NEGR%' THEN 'black' WHEN ramal like 'VERDE%' THEN 'green' 
 WHEN ramal like '%AERO%' THEN 'AERO' WHEN ramal like '%CABIN%' THEN 'CABIN' WHEN ramal like '%SOLDINI%' THEN 'SOLDINI'
 ELSE 'cyan' END as route_color,
 tup4326.linea as route_text_color 
 from "tup4326" as tup4326 inner join "ramales" as ramales on tup4326.id_ramal = ramales.id_ramal
 		left join tupcodsms on tupcodsms.id_ramal = ramales.id_ramal
 where route_name like '%Vuelta' 
 --and tup4326.id_ramal <> 65 -- quito LC 
 --and ramales.id_ramal in (26,27,16,23,24,25,29,32,33)
 --order by left(route_name, length(route_name) - 7)
--route_short_name,route_id,route_type,agency_id,route_long_name,route_color,route_text_color
--101,1,3,1,,,





