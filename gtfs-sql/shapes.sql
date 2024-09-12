--select id_tup, ST_DumpPoints(geom) from tup
--create view shapes3 as (
 WITH segments AS (
    SELECT id_ramal as shape_id , st_y((pt).geom) as shape_pt_lat, st_x((pt).geom) as shape_pt_lon, CASE sentido when 'IDA' then 0 else 1000 END + (pt).path[1] as shape_pt_sequence, (pt).geom, sentido
    FROM (SELECT tup4326.id_ramal, sentido, st_dumppoints((st_makeline(ST_LineMerge(geom)))) AS pt FROM "tup4326" as tup4326 inner join "ramales" as ramales on tup4326.id_ramal = ramales.id_ramal  group by tup4326.id_ramal, sentido order by sentido) as dumps
    )
SELECT distinct shape_id, shape_pt_lat, shape_pt_lon,shape_pt_sequence,'' as  shape_dist_traveled FROM segments WHERE geom IS NOT NULL
order by shape_id, shape_pt_sequence

--shape_id,shape_pt_lat,shape_pt_lon,shape_pt_sequence,shape_dist_traveled
--2133,-32.8719625524,-68.8626655378,1,
--2133,-32.8720242213,-68.8613606431,2,
--2133,-32.8720622364,-68.8608925976,3,
--2133,-32.8721385482,-68.860120792,4,

--select * from shapes3