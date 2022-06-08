/* add a value streamsize to determine the number of avamar streams to add to the backup (max 10)*/ 

declare @streamsize decimal(8,4)
set @streamsize = 256.0000;


with d as

(
SELECT --DISTINCT
    SUBSTRING(volume_mount_point, 1, 1) AS volume_mount_point,
	/* return the partition name when it exists otherwise drive letter*/
	CASE WHEN LEN(volume_mount_point) > 3
	then
	SUBSTRING(volume_mount_point, 4, len(volume_mount_point) - 4) 
	else 
	volume_mount_point 
	END AS shortcut,
	volume_id,
	size/1024*8 as DB_Size,
	    total_bytes/1024/1024 AS total_MB
    ,available_bytes/1024/1024 AS available_MB
	from sys.master_files f
	/* temp db reflected inaccurately */
	

CROSS APPLY
    sys.dm_os_volume_stats(f.database_id, f.file_id)
	where name not like 'temp%'
),

--245717
--select volume_mount_point, shortcut, sum(DB_Size) as total_database_size_MB, volume_id, total_MB, available_MB  from d
--group by volume_mount_point, shortcut, volume_id, total_MB, available_MB

/* create a second cte to accurately track tempdb */

--with 
c as(

SELECT -- s.[database_id]

	-- @@SERVERNAME as 'ServerName'
	 -- s.[name] as 'FileName'
	 -- ,
	sd.name as 'DatabaseName' 
   
	  ,case when [type] = 0
	  then [size] * 8/1024
	  else ''
	  end
	  as 'Database Size'
	  ,case when [type] = 1
	  	  then [size] * 8/1024
	  else ''
	  end
	  as 'Log Size'
	  , physical_name
	  , [size] * 8/1024 as 'Total DB Size'

  FROM [master].[sys].[master_files] s

  -- with rollup
  join sys.databases sd on sd.database_id = s.database_id
  where sd.name <> 'tempdb'
  and sd.state_desc = 'ONLINE'
 -- group by  sd.name 
 
  )

  /* now get the sum of each database and group by database name to get the sum off all databases */
 
    
  SELECT 
  DatabaseName,
  --c.physical_name,
    SUM(c.[Database Size]) as 'Total Database Size',
	--@streamsize as 'Streamsize',
	--CEILING(SUM(c.[Database Size])/@streamsize ) as 'Number of Avamar Streams',--+ cast @streamsize as nvarchar(max))+' streams',
	--cast (SUM(c.[Database Size])/@streamsize as decimal(8,4)),
  SUM(c.[Log Size]) as 'Total Log File Size',
  SUM(c.[Total DB Size]) as 'Total File Size'
  
  from c
  group by DatabaseName --, physical_name
  with rollup
  go



with a as(
SELECT --DISTINCT
    SUBSTRING(volume_mount_point, 1, 1) AS volume_mount_point,
	/* return the partition name when it exists otherwise drive letter*/
	CASE WHEN LEN(volume_mount_point) > 3
	then
	SUBSTRING(volume_mount_point, 4, len(volume_mount_point) - 4) 
	else 
	volume_mount_point 
	END AS shortcut,
	volume_id,
	size/1024*8 as DB_Size,
	    total_bytes/1024/1024 AS total_MB
    ,available_bytes/1024/1024 AS available_MB


	,case when [type] = 0
	  then [size] * 8/1024
	  else ''
	  end
	  as 'Database Size'
	  ,case when [type] = 1
	  	  then [size] * 8/1024
	  else ''
	  end
	  as 'Log Size'
	  , physical_name
	  , [size] * 8/1024 as 'Total DB Size'

	--, *
	from sys.master_files f
	/* temp db reflected inaccurately */
	

CROSS APPLY
    sys.dm_os_volume_stats(f.database_id, f.file_id)
	where name not like 'temp%'
) 


select volume_mount_point as 'volume_mount_point Log and Data', shortcut, sum([Database Size]) as 'Database Size', SUM([Log Size]) as 'Log Size', sum(DB_Size) as total_database_log_size_MB, 

volume_id, total_MB, available_MB  from a
group by volume_mount_point, shortcut, volume_id, total_MB, available_MB --, [Database Size], [Log Size]


  /* get the data from temp db */



 use tempdb

 select  m.name as 'TempDB filename', --m.physical_name as physical_file_name
 (size * 8 / 1024 ) as 'size MB'
, case when max_size < 0 then cast('Unlimited' as nvarchar) 
else 
cast(cast(max_size as bigint) * 8 / 1024 as nvarchar)
end
'max size MB'
--,(cast(max_size as bigint) * 8 / 1024 ) as 'max size MB' 
from sys.database_files m
join sys.sysdatabases s
on s.dbid = m.file_id

select volume_mount_point as 'volume_mount_point TempDB', shortcut, sum(DB_Size) as total_database_size_MB, volume_id, total_MB, available_MB  from 

(
select  
SUBSTRING(volume_mount_point, 1, 1) AS volume_mount_point,
	/* return the partition name when it exists otherwise drive letter*/
	CASE WHEN LEN(volume_mount_point) > 3
	then
	SUBSTRING(volume_mount_point, 4, len(volume_mount_point) - 4) 
	else 
	volume_mount_point 
	END AS shortcut,
	volume_id,

--	m.name as filename, --m.physical_name as physical_file_name
 (size * 8 / 1024 ) as DB_Size,
 	    total_bytes/1024/1024 AS total_MB
    ,available_bytes/1024/1024 AS available_MB
--,case when max_size < 0 then cast('Unlimited' as nvarchar) 
--else 
--(max_size * 8 / 1024 ) as 'max size MB' 
--use tempdb
--select * 

from sys.database_files m
--join sys.sysdatabases s
--on s.file_id = m.file_id
CROSS APPLY
    sys.dm_os_volume_stats((select database_id from sys.databases m where name like 'tempdb%'), m.file_id)
) e

group by volume_mount_point, shortcut, volume_id, total_MB, available_MB







