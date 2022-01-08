create table mydatabase.cp_maps
	select distinct row_names,who,lat,lng,`when` 
    from mydatabase.maps;

SELECT * FROM mydatabase.cp_maps;

drop table mydatabase.maps;

ALTER TABLE mydatabase.cp_maps RENAME TO mydatabase.maps;