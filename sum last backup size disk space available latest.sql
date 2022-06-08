--use master
use msdb

declare @drivecount int,
@getDrive varchar(2),
@getMB_free int,
@Drive1 varchar(2),
@MB_free1 int,
@Drive2 varchar(2),
@MB_free2 int,
@Drive3 varchar(2),
@MB_free3 int,
@Drive4 varchar(2),
@MB_free4 int

if exists(select * from tempdb.sys.objects where name like '%#tbl_xp_fixeddrives%')
drop table #tbl_xp_fixeddrives


CREATE TABLE #tbl_xp_fixeddrives
(Drive varchar(2) NOT NULL,
[MB free] int NOT NULL)

INSERT INTO #tbl_xp_fixeddrives(Drive, [MB free])
EXEC master.sys.xp_fixeddrives

set @drivecount = 1

--set @drivecount = (select count(*) from #tbl_xp_fixeddrives )
--print @drivecount

declare get_drivespace cursor 
for
select Drive,
[MB free] 
from 
#tbl_xp_fixeddrives
order by Drive

open get_drivespace

fetch next from get_drivespace into  @getDrive, @getMB_free 
WHILE @@FETCH_STATUS = 0
Begin
--print  @getDrive
--print @getMB_free 


	if @drivecount = 1 
	select @Drive1 = @getDrive,
	  @MB_free1 = @getMB_free

	 print @Drive1
	 print @MB_free1
	
	 If @drivecount = 2
	 select @Drive2 = @getDrive,
	 @MB_free2 = @getMB_free

	print @Drive2
	print @MB_free2

	If @drivecount = 3
select @Drive3 = @getDrive,
@MB_free3 = @getMB_free

if @drivecount = 4
select @Drive4 = @getDrive,
@MB_free4 = @getMB_free

set @drivecount = @drivecount + 1
fetch next from get_drivespace into  @getDrive, @getMB_free 


end
close get_drivespace
deallocate get_drivespace;

--drop table #tbl_xp_fixeddrives

--select * from (

WITH c as
(
select 
server_name, 
database_name, --a.name, 
backup_set_id,
--(cast([software_major_version] as nvarchar) + '.' + cast([software_minor_version] as nvarchar) 
  --+ '.' + cast([software_build_version] as nvarchar)) as 'Version Number',

--a.[backup_finish_date] as 'Most Recent Backup', --(cast(convert(decimal, (a.backup_size/1024)) as numeric(8,4))),
(convert(int, (backup_size/(POWER(1024,2))))) as 'Backup MB'
-- a.recovery_model, 
--b.physical_device_name, 
--@Drive1 [drive 1],
--@MB_free1 [drive 1 space available],
--@Drive2 [drive 2],
--@MB_free2 [drive 2 space available],
--@Drive3 [drive 3],
--@MB_free3 [drive 3 space available],
--@Drive4 [drive 4],
--@MB_free4 [drive 4 space available]

from msdb.dbo.backupset 

),  --join msdb.dbo.backupmediafamily b
--  on a.media_set_id = b.media_set_id
--where (a.[database_name] not in ('master','msdb','model'))
--group by 
-- a.server_name, a.database_name, [software_major_version], [software_minor_version], [software_build_version], a.backup_size, b.physical_device_name
 
a1 as
 (
 select 

--database_name,  
backup_set_id, max([backup_finish_date]) as 'Most_Recent_Full_Backup'
FROM [dbo].[backupset] b
join msdb.dbo.backupmediafamily a
on a.media_set_id  = b.media_set_id 
--where recovery_model = 'FULL' and 
where Type = 'D'
and a.device_type = 7
group by --database_name
backup_set_id
 ), 

 

a2 as
 (
  select max([backup_set_id]) as [backup_set_id], database_name from msdb.dbo.backupset
 
-- where recovery_model = 'FULL' and 
--Type = 'D'
group by database_name 
 ),

 a3 as
 (

 select c.database_name, sum([Backup MB]) as [GT Backup MB]
  from c
  
   join
 a1 on a1.backup_set_id = c.backup_set_id
 join
 a2 on a2.backup_set_id = a1.backup_set_id
  where (c.[database_name] not in ('master','msdb','model'))
 group by rollup(c.database_name)

 )
 --sum(c.[Backup MB]) over(--partition by c.database_name
 --order by c.database_name
 --rows between unbounded preceding and current row) 
 
 --a4 as
 --(
 select a3.*,
case when a3.database_name is null then
@Drive1 
else ''
end,
case when a3.database_name is null then
@MB_free1 
else ''
end,
case when a3.database_name is null then
(@MB_free1 - [GT Backup MB]) 
else ''
end,

case when a3.database_name is null then
@Drive2 
else ''
end,
case when a3.database_name is null then
@MB_free2 
else ''
end,
case when a3.database_name is null then
(@MB_free2 - [GT Backup MB]) 
else ''
end,

case when a3.database_name is null then
@Drive3 
else ''
end,
case when a3.database_name is null then
@MB_free3 
else ''
end,
case when a3.database_name is null then
(@MB_free3 - [GT Backup MB]) 
else ''
end,

case when a3.database_name is null then
@Drive4 
else ''
end,
case when a3.database_name is null then
@MB_free4 
else ''
end,
case when a3.database_name is null then
(@MB_free4 - [GT Backup MB]) 
else ''


end




--@MB_free1 ,
--@Drive2 [drive 2],
--@MB_free2 [drive 2 space available],
--@Drive3 [drive 3],
--@MB_free3 [drive 3 space available],
--@Drive4 [drive 4],
--@MB_free4 [drive 4 space available]

from a3

--)

--select database_name, [GT Backup MB] from a4
--where database_name is not null;


--with a5 as
--(select * from a4
--where a4.database_name is null)
--select * from a5  






 




  
  
 --group by rollup (a.database_name, a.backup_size);
-- and b.device_type = 7

-- join 
--	 (
--	select 

--	database_name, max([backup_finish_date]) as 'Most_Recent_Full_Backup'
--	FROM [dbo].[backupset]
--	where recovery_model = 'FULL' and Type = 'D'
--	group by database_name
--	) as a1

--) as a2
-- on a1.backup_set_id = a.backup_set_id 
 

--  select 

--database_name, max([backup_finish_date]) as 'Most_Recent_Full_Backup'
--FROM [dbo].[backupset]
--where recovery_model = 'FULL' and Type = 'D'
--group by database_name


 --select power(1024,3)

 --select * from msdb.dbo.backupset a

-- where (a.[database_name] not in ('master','msdb','model'))