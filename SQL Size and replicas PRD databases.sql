--declare @servername nvarchar(1000)

--set @servername = (select @@servername)

--if (select @@servername) like '%PR%'

----or ((select @@servername) like 'ME-%' and @@servername not in ('%DEV%','%QA%','%UAT%'))

----print @servername

--begin 

with restore_history as 
(


SELECT


  restorehistory.destination_database_name 'Database Name'
, max(restorehistory.restore_date) as 'Create Date'
--, max(restorehistory.restore_type) as 'restore type'
--, max(backupset.user_name) as 'restore user name'
, max(backupset.server_name) 'Originating Server'
, max(backupset.database_name) 'Originating Database'
, max(backupset.backup_finish_date) as 'Originating Backup Finish Date'
FROM
  msdb.dbo.restorehistory
    INNER JOIN
  msdb.dbo.BackupSet ON restorehistory.backup_set_id = backupset.backup_set_id


group by restorehistory.destination_database_name
)

SELECT DISTINCT
f.name as'Logical Name', 
db_name(f.database_id) as 'Database Name',
--f.physical_name as 'Physical Name',  
cast(f.size  as bigint) * 8 /1024 as 'Size MB'
, restore_history.[Create Date]
, restore_history.[Database Name]
, restore_history.[Originating Backup Finish Date]
, restore_history.[Originating Database]
, restore_history.[Originating Server]



--case when f.max_size in (-1, 0) then f.max_size  -- infinite
--else cast(f.max_size  as bigint) * 8 /1024
--end
--as 'Max Size MB', 

--f.max_size,
--f.type_desc,
 --   SUBSTRING(volume_mount_point, 1, 1) AS volume_mount_point,
	--/* return the partition name when it exists otherwise drive letter*/
	--CASE WHEN LEN(volume_mount_point) > 3
	--then
	--SUBSTRING(volume_mount_point, 4, len(volume_mount_point) - 4) 
	--else 
	--volume_mount_point 
	--END AS shortcut,
	--volume_id
    --,
	--total_bytes/1024/1024 AS 'total MB on volume'
    --,available_bytes/1024/1024 AS 'available MB on volume'
	--,s.recovery_model_desc
FROM
    sys.master_files AS f
	join sys.databases s
on s.database_id = f.database_id
left join restore_history on restore_history.[Database Name] = db_name(f.database_id)

CROSS APPLY
   sys.dm_os_volume_stats(f.database_id, f.file_id)

where type_desc = 'ROWS'
and SUBSTRING(volume_mount_point, 1, 1)  <> '\'

end



	


