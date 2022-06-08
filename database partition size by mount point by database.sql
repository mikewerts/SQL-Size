SELECT DISTINCT
f.name as'Logical Name', 
db_name(f.database_id) as 'Database Name',
f.physical_name as 'Physical Name',  
cast(f.size  as bigint) * 8 /1024.00 as 'Size MB', 
case when f.max_size in (-1, 0) then f.max_size  -- infinite
else cast(f.max_size  as bigint) * 8 /1024
end
as 'Max Size MB', 

f.max_size,
f.type_desc,
    SUBSTRING(volume_mount_point, 1, 1) AS volume_mount_point,
	/* return the partition name when it exists otherwise drive letter*/
	CASE WHEN LEN(volume_mount_point) > 3
	then
	SUBSTRING(volume_mount_point, 4, len(volume_mount_point) - 4) 
	else 
	volume_mount_point 
	END AS shortcut,
	volume_id
    ,
	total_bytes/1024/1024 AS 'total MB on volume'
    ,available_bytes/1024/1024 AS 'available MB on volume'
	,s.recovery_model_desc
FROM
    sys.master_files AS f
	join sys.databases s
on s.database_id = f.database_id

CROSS APPLY
    sys.dm_os_volume_stats(f.database_id, f.file_id)

	--where type_desc = 'LOG'

where f.name not like '%temp%'

--where volume_mount_point = 'C' 
--and db_name(f.database_id) like '%claimsx%'
/* tempdb size not accurately reflected in sys.master_files*/

/*
select * from sys.master_files
 select * from sys.database_files m

select * from sys.dm_os_volume_stats(4, 1)
*/

/*
use tempdb

select  m.name as filename, m.physical_name as physical_file_name, (size * 8 / 1024.0 /1024.0) as 'size GB'
, (max_size * 8 / 1024.0 /1024.0) as 'max size GB' from sys.database_files m
*/

	order by volume_mount_point desc
--, volume_id desc



	
