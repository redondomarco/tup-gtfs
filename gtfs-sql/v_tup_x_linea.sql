-- View: public.v_tup_x_linea

-- DROP VIEW public.v_tup_x_linea;

CREATE OR REPLACE VIEW public.v_tup_x_linea
 AS
SELECT tup4326.id_ramal,
    sum(st_length(tup.geom)) AS longitud,
    sum(
        CASE
            WHEN tup4326.sentido::text ~~ '%IDA'::text THEN st_length(tup.geom)
            ELSE 0::double precision
        END) AS longitud_ida,
    sum(
        CASE
            WHEN tup4326.sentido::text ~~ '%VUELTA'::text THEN st_length(tup.geom)
            ELSE 0::double precision
        END) AS longitud_vuelta,
    st_makeline(st_linemerge(tup4326.geom)) AS geom
   FROM (select id_tup, st_transform(ST_SetSRID(tup4326.geom,4326),22185) as geom from tup4326) as tup
     JOIN tup4326 tup4326 ON tup.id_tup = tup4326.id_tup
  GROUP BY tup4326.id_ramal;
  
ALTER TABLE public.v_tup_x_linea
    OWNER TO aricagn0;

 
