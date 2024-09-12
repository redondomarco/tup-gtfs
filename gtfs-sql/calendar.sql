select 'default' as service_id, '20000101' as start_date, '20991201' as end_date, 1 as monday, 1 as tuesday, 1 as wednesday, 1 as thursday, 1 as friday, 1 as saturday, 1 as sunday
UNION ALL
select 'lc' as service_id, '20000101' as start_date, '20991201' as end_date, 0 as monday, 0 as tuesday, 0 as wednesday, 0 as thursday, 0 as friday, 1 as saturday, 1 as sunday

