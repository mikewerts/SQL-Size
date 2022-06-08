drop table #Last_12_Month_Backup
drop table #Last_12_Month_Backup_unpivot
--drop table #Last_12_Month_Backup_trend
drop table #Last_12_Month_Backup_trend_forecast
drop table #trendlines
drop table #CTE_AllIDs
drop table #Sum_by_database_name
drop table #Get_volume_mount_points
drop table #Get_datafiles
drop table #Get_logfiles
drop table #Get_group_trend

Create table #Last_12_Month_Backup
(
DatabaseName nvarchar(max)
    
,[1] NUMERIC(10, 1)
	,[2] NUMERIC(10, 1)
	,[3] NUMERIC(10, 1)
	,[4] NUMERIC(10, 1)
	,[5] NUMERIC(10, 1)
	,[6] NUMERIC(10, 1)
	,[7] NUMERIC(10, 1)
	,[8] NUMERIC(10, 1)
	,[9] NUMERIC(10, 1)
	,[10] NUMERIC(10, 1)
	,[11] NUMERIC(10, 1)
	,[12] NUMERIC(10, 1)
	--,[0] NUMERIC(10, 1)

)




DECLARE @startDate DATETIME;
declare @databasename nvarchar(max);
declare @DatabaseName2 nvarchar(max);
declare @val as int;
set @val = 1


SET @startDate = GetDate();

--insert into #Last_12_Month_Backup



with Last_12_Month_BU_Ave as 
(
SELECT PVT.DatabaseName as DatabaseName 
--,PVT.[-12] - PVT.[-13] as [-13]   
/*
,PVT.[-11] - PVT.[-12]  as [-12]
	,PVT.[-10] - PVT.[-11] as [-11]
	,PVT.[-9] - PVT.[-10] as [-10]
	,PVT.[-8] - PVT.[-9] as [-9]
	,PVT.[-7] - PVT.[-8] as [-8]
	,PVT.[-6] - PVT.[-7] as [-7]
	,PVT.[-5] - PVT.[-6] as [-6]
	,PVT.[-4] - PVT.[-5] as [-5]
	,PVT.[-3] - PVT.[-4] as [-4]
	,PVT.[-2] - PVT.[-3] as [-3]
	,PVT.[-1] - PVT.[-2] as [-2]
	,PVT.[0]  - PVT.[-1] as [-1]
*/
	,PVT.[-12]  as [-12]
	,PVT.[-11] as [-11]
	,PVT.[-10] as [-10]
	, PVT.[-9] as [-9]
	,PVT.[-8] as [-8]
	,PVT.[-7] as [-7]
	,PVT.[-6] as [-6]
	,PVT.[-5] as [-5]
	,PVT.[-4] as [-4]
	,PVT.[-3] as [-3]
	,PVT.[-2] as [-2]
	,PVT.[-1] as [-1]
	--,-- as [0]
FROM (

--DECLARE @startDate DATETIME;
--SET @startDate = GetDate();

    SELECT BS.database_name AS DatabaseName
   ,DATEDIFF(mm, @startDate, BS.backup_start_date) AS MonthsAgo
   --     ,CONVERT(NUMERIC(10, 1), AVG(BF.file_size / 1048576.0)) AS AvgSizeMB
   ,CONVERT(NUMERIC(10, 1), AVG(BS.backup_size / 1048576.0)) AS AvgSizeMB
  FROM msdb.dbo.backupset AS BS
    INNER JOIN msdb.dbo.backupfile AS BF ON BS.backup_set_id = BF.backup_set_id
    WHERE BS.database_name 
	
	NOT IN (
            'master'
            ,'msdb'
            ,'model'
            ,'tempdb'
            )

		 --= 'Beacon'
        AND BS.database_name IN (
            SELECT db_name(database_id)
            FROM master.SYS.DATABASES
            WHERE state_desc = 'ONLINE'
            )
        AND BF.[file_type] = --'L' 
		'D' --for databases
       AND BS.backup_start_date BETWEEN DATEADD(yy, - 1, @startDate)
          AND @startDate
    GROUP BY BS.database_name
       ,DATEDIFF(mm, @startDate, BS.backup_start_date)
    ) AS BCKSTAT
PIVOT(SUM(BCKSTAT.AvgSizeMB) FOR BCKSTAT.MonthsAgo IN (
--         [-13]
		  -- ,
		  [-12]
	,[-11]
	,[-10]
	,[-9]
	,[-8]
	,[-7]
	,[-6]
	,[-5]
	,[-4]
	,[-3]
	,[-2]
	,[-1]
	,[0]
            )) AS PVT
			
--ORDER BY PVT.DatabaseName
)

insert into #Last_12_Month_Backup	select *  from Last_12_Month_BU_Ave

--select * from #Last_12_Month_Backup




Create table #Last_12_Month_Backup_unpivot
(

MonthsAgo  int
,DatabaseName nvarchar(max)
,AvgSizeMB  decimal(9,2)
,trend DECIMAL(38, 10) default null
,slope decimal(9,2)

)



insert into #Last_12_Month_Backup_unpivot

select   MonthsAgo, DatabaseName, U.AvgSizeMB, null, null --, --as Average_Growth_MB  

	from #Last_12_Month_Backup
	unpivot (AvgSizeMB  FOR MonthsAgo IN
	(
	           --[-13]
		  [1] 
	,[2] 
	,[3] 
	,[4] 
	,[5] 
	,[6] 
	,[7] 
	,[8] 
	,[9] 
	,[10] 
	,[11] 
	,[12] 
	))
	as u
	/* placeholder for data from one database */
	--where DatabaseName = 'Beacon'


/* new table with forecast */

Create table #Last_12_Month_Backup_trend_forecast
(

MonthsAgo  int
,DatabaseName nvarchar(max)
,AvgSizeMB  decimal(9,2)
,Trend DECIMAL(38, 10) default null
,slope DECIMAL(38, 10)


)

/* Create table with sum by database name */

Create table #Sum_by_database_name
(
[database_id] int,
[DatabaseName] nvarchar(max),
[volume_mount_point] nvarchar(512),
[Total Current Database Size] int, 
[Total Projected Size] int,
[Sum Log File Size (current)] int, 
[Sum Total Projected Size] int

)

Create table #Get_volume_mount_points
(
	volume_mount_point  nvarchar(512),
	volume_id nvarchar(512),
	DB_Size int,
	total_MB int,
    available_MB int
)	

Create table #Get_datafiles
(
	[database_id] int,
	[DatabaseName] nvarchar(max)
	,[volume_mount_point] nvarchar(512)
	,[Database Size] int
	,[available_MB] int
)

Create table #Get_logfiles
(
	[database_id] int,
	[DatabaseName] nvarchar(max)
	,[volume_mount_point] nvarchar(512)
	,[Database Size] int
	,[available_MB] int
)

Create table #Get_group_trend

(
[database_id] int,
[DatabaseName] nvarchar(max),
[Projected Size 12 Months (MB)] int,
[Slope] decimal(9,2)


)
/* create static temp table with 24 sequential numeric rows to join and show forecast data in months */




declare @id int 
set @id = 1



create table #CTE_AllIDs 
(ID int
);
while @id < 25 
begin 
	
	insert  into #CTE_AllIDs(ID) select @id -- (@id) 
	set @id = @id + 1
	--print @id
end

/* create table for linear forecasting components */

create table #trendlines 
(
databasename nvarchar(max),
SampleSize INT, 
sumX   DECIMAL(38, 10),
sumY   DECIMAL(38, 10),
sumXX   DECIMAL(38, 10),
sumYY   DECIMAL(38, 10),
sumXY   DECIMAL(38, 10),
--trend DECIMAL(38, 10)
);


--select * from #CTE_AllIDs

-- declare all variables
DECLARE @sample_size INT; 
DECLARE @intercept  DECIMAL(38, 10);
DECLARE @slope   DECIMAL(38, 10);
DECLARE @sumX   DECIMAL(38, 10);
DECLARE @sumY   DECIMAL(38, 10);
DECLARE @sumXX   DECIMAL(38, 10);
DECLARE @sumYY   DECIMAL(38, 10);
DECLARE @sumXY   DECIMAL(38, 10);
declare @trend DECIMAL(38, 10);

/* declare cursor to calculate sample size and the different sums for each database */

declare dbcursor cursor
for 
select DatabaseName from #Last_12_Month_Backup 
 open  dbcursor  

 fetch next from dbcursor
 into @DatabaseName

 while @@fetch_status = 0
 begin

SELECT
  @sample_size = COUNT(*)
 ,@sumX   = SUM(MonthsAgo)
 ,@sumY   = SUM([AvgSizeMB])
 ,@sumXX   = SUM(MonthsAgo*MonthsAgo)
 ,@sumYY   = SUM([AvgSizeMB]*[AvgSizeMB])
 ,@sumXY   = SUM(MonthsAgo*[AvgSizeMB])

 /* get the slope ind intercept for each database */
FROM #Last_12_Month_Backup_unpivot
where DatabaseName = @DatabaseName
--where DatabaseName = 'Beacon'

insert into #trendlines
SELECT
  databasename = @databasename
  ,SampleSize   = @sample_size  
 ,sumX    = @sumX   
 ,sumY		=@sumY   
 ,SumXX    = @sumXX   
 ,SumYY    = @sumYY   
 ,SumXY    = @sumXY



 -- calculate the slope and intercept
SET @slope = CASE WHEN @sample_size = 1
    THEN 0 -- avoid divide by zero error
    ELSE (@sample_size * @sumXY - @sumX * @sumY) / (@sample_size * @sumXX - POWER(@sumX,2))
    END;
SET @intercept = (@sumY - (@slope*@sumX)) / @sample_size;
--Now that we have found the slope and the intercept, we can easily calculate the linear trendline in each x-coordinate. We store the results in the temp table.

--declare @trend DECIMAL(38, 10)
	
/* calculate trend line */
	UPDATE #Last_12_Month_Backup_unpivot
	SET Trend = (@slope*MonthsAgo) + @intercept
	where DatabaseName = @DatabaseName;

	update #Last_12_Month_Backup_unpivot
	set slope = @slope
	where DatabaseName = @DatabaseName;

/* now calculate the forecast */

with butrend as 
(
SELECT
  --c.ID as 
  MonthsAgo
  ,DatabaseName
 ,AvgSizeMB
 ,Trend
 ,slope
 
	FROM  #Last_12_Month_Backup_unpivot --#CTE_AllIDs   c 
	where DatabaseName = @DatabaseName
	--where DatabaseName = 'Beacon'
	),

joinbutrend as
(


	--insert into #Last_12_Month_Backup_trend_forecast
	select 
	c.ID as MonthsAgo
	,butrend.DatabaseName
	,butrend.AvgSizeMB
	,butrend.Trend
	,butrend.slope
		from #CTE_AllIDs c
		
		

		/* now outer join to calculate the forecast for 12 months out*/

	   left JOIN butrend ON c.ID = butrend.MonthsAgo	
	   
	   ) 

	   --select * from joinbutrend
	  

	 insert into #Last_12_Month_Backup_trend_forecast

	 
	   select joinbutrend.MonthsAgo - 12 as [month], @DatabaseName, joinbutrend.AvgSizeMB, -- Trend, --from joinbutrend

	   Trend = Case when  joinbutrend.MonthsAgo <= (SELECT MAX(joinbutrend.MonthsAgo) from joinbutrend where DatabaseName = @DatabaseName)
        THEN joinbutrend.Trend
       
       WHEN joinbutrend.MonthsAgo > (SELECT MAX(joinbutrend.MonthsAgo) from joinbutrend where DatabaseName = @DatabaseName)
        THEN (@slope * (MonthsAgo % 100)) + @intercept
      -- ELSE NULL
       END,
	   slope = 
	    /* slope < 1 set to 1 */
	   case when ((@slope * (24 % 100)) + @intercept) /((@slope * (12 % 100)) + @intercept) < 1
		then 1
	  /* slope > 1 */
	   else ((@slope * (24 % 100)) + @intercept) /((@slope * (12 % 100)) + @intercept)
	   end



		from joinbutrend

		


	FETCH NEXT from dbcursor into @DatabaseName 

	 END   
CLOSE dbcursor;  
DEALLOCATE dbcursor;	


 -- select * from #Last_12_Month_Backup_trend_forecast


/* now get the current size of the log files */
with 
log_files as(

SELECT -- s.[database_id]

	-- @@SERVERNAME as 'ServerName'
	 -- s.[name] as 'FileName'
	 -- ,
	 s.database_id as 'database_id',
	 
		s.name as 'DatabaseName', 
		volume_mount_point as 'volume_mount_point'
	  ,[size] * 8/1024
	  as 'Log Size'
	  ,available_bytes/1024/1024 AS 'available_MB'
	 

  FROM [master].[sys].[master_files] s





    -- with rollup
  join sys.databases sd on sd.database_id = s.database_id
  CROSS APPLY
    sys.dm_os_volume_stats(s.database_id, s.file_id)
	where s.name not like 'temp%'
  and s.[type] = 1
  and sd.name <> 'tempdb'
  and sd.state_desc = 'ONLINE'
 -- group by  sd.name 
 
  )

  insert into #Get_logfiles
select * from log_files;

  /* now get the data files */

   
with data_files as(

SELECT
s.database_id as 'database_id',
 s.name as 'DatabaseName',
 volume_mount_point as 'volume_mount_point'
   
	  ,
	   [size] * 8/1024
	  as 'Database Size'
	  ,available_bytes/1024/1024 AS 'available_MB'
	 

 --select *  
 FROM [master].[sys].[master_files] s

    -- with rollup
  join sys.databases sd on sd.database_id = s.database_id
    CROSS APPLY
    sys.dm_os_volume_stats(s.database_id, s.file_id)
	where s.name not like 'temp%'
  and s.[type] = 0
  and sd.name <> 'tempdb'
  and sd.state_desc = 'ONLINE'
 -- group by  sd.name 
 
  )



insert into #Get_datafiles
select * from data_files
;

 -- select * from #Last_12_Month_Backup_trend_forecast

  /* sum the trendlines and group with rollup */

with group_trend as(
select m.database_id, DatabaseName, cast((Trend) as int) as 'Projected Size 12 Months (MB)' 
,slope
--, 
--sum(c.[Database Size]) as 'Current Database Size', 
--sum(c.[Log Size]) as 'Total Log File Size' 
from #Last_12_Month_Backup_trend_forecast
join master.SYS.DATABASES m on db_name(m.database_id) = DatabaseName

--join log_files on log_files.DatabaseName = #Last_12_Month_Backup_trend_forecast.DatabaseName
where MonthsAgo = 12

--group by rollup(DatabaseName) 
)

insert into #Get_group_trend
select * from group_trend;




with projected_growth_db as (
select --#Get_group_trend.database_id,
#Get_group_trend.DatabaseName, 

sum(cast(#Get_datafiles.[Database Size] as int)) as 'Current Database Size', 
case when sum(#Get_group_trend.[Projected Size 12 Months (MB)]) < sum(#Get_datafiles.[Database Size])
/* trendline lags behind current DB size */
then sum(cast(#Get_datafiles.[Database Size] * slope as int))
else 
/* use trendline */
sum(cast(#Get_group_trend.[Projected Size 12 Months (MB)] as int)) 
end as 'Projected Size 12 Months (MB)', 
sum(cast(#Get_logfiles.[Database Size] as int)) as 'Total Log File Size (current)', 
sum(cast(#Get_group_trend.[Projected Size 12 Months (MB)] + #Get_logfiles.[Database Size] as int)) as 'Total Projected Size'--,
--sum(slope)
from #Get_group_trend
join #Get_datafiles on #Get_datafiles.[database_id] = #Get_group_trend.[database_id]
join #Get_logfiles on #Get_logfiles.[database_id] = #Get_group_trend.[database_id]
--group by #Get_group_trend.DatabaseName
group by rollup(#Get_group_trend.DatabaseName) 
)

select * from projected_growth_db
--group by rollup(DatabaseName)

 ;
 
 /* enter current size, projected size, and mount points for data and log files */


with projected_growth_volume as (
select --#Get_group_trend.database_id,
#Get_datafiles.volume_mount_point as 'Volume Mount Point',
sum(cast(#Get_datafiles.[Database Size] as int)) as 'Current Database Size', 
0 as 'Total Log File Size (current)',
case when sum(#Get_group_trend.[Projected Size 12 Months (MB)]) < sum(#Get_datafiles.[Database Size])
/* trendline lags behind current DB size */
then sum(cast(#Get_datafiles.[Database Size] * slope as int))
else 
/* use trendline */
sum(cast(#Get_group_trend.[Projected Size 12 Months (MB)] as int))
end as 'Projected Size 12 Months (MB)',
max(#Get_datafiles.[available_MB]) as 'Available MB'

from #Get_group_trend
join #Get_datafiles on #Get_datafiles.[database_id] = #Get_group_trend.[database_id] 
group by #Get_datafiles.volume_mount_point

union all
select 
#Get_logfiles.volume_mount_point as 'Volume Mount Point',
0 as 'Current Database Size',
sum(cast(#Get_logfiles.[Database Size] as int)) as 'Total Log File Size (current)', 
0 as 'Projected Size 12 Months (MB)',
max(#Get_logfiles.[available_MB]) as 'Available MB'

--sum(slope)
from #Get_group_trend
--join #Get_datafiles on #Get_datafiles.[database_id] = #Get_group_trend.[database_id]
join #Get_logfiles on #Get_logfiles.[database_id] = #Get_group_trend.[database_id]

group by #Get_logfiles.volume_mount_point
--group by #Get_group_trend.DatabaseName
--group by rollup(group_trend.DatabaseName) 

)



select [Volume Mount Point], sum([Current Database Size]) as 'Current Database Size', 
sum([Projected Size 12 Months (MB)]) as 'Projected Size 12 Months (MB)', 
sum([Total Log File Size (current)]) as 'Total Log Size',
sum([Projected Size 12 Months (MB)]) + sum([Total Log File Size (current)]) as 'Total Projected Size (12 Months)',
max([Available MB]) as 'Available MB',
max([Available MB]) - (sum([Projected Size 12 Months (MB)]) - sum([Current Database Size])) as 'Available MB (12 Months)'
from projected_growth_volume
group by [Volume Mount Point]








--select * from #Get_group_trend

--select * from #Get_datafiles

--select * from #Get_logfiles

--select * from #Sum_by_database_name






/*
projected_growth_by_database as (
--select g.shortcut,
select
group_trend.DatabaseName,
--group_data.volume_mount_point as 'Volume', 
sum(cast(group_data.[Database Size] as int)) as 'Current Database Size', 
case when sum([Projected Size 12 Months (MB)]) < sum(group_data.[Database Size])
/* trendline lags behind current DB size */
then sum(cast(group_data.[Database Size] * slope as int))
else 
/* use trendline */
sum(cast([Projected Size 12 Months (MB)] as int)) 
end as 'Projected Size 12 Months (MB)'
from group_trend
join group_data on group_data.DatabaseName = group_trend.DatabaseName

/* get logs and databases in one table */
group by group_trend.DatabaseName 

)


select * from projected_growth_by_database

projected_log_by_database 
(

--union all

select group_trend.DatabaseName,
--group_log.volume_mount_point as 'Volume',
sum(cast(group_log.[Log Size] as int)) as 'Total Log File Size (current)', 
sum(cast([Projected Size 12 Months (MB)] + group_log.[Log Size] as int)) as 'Total Projected Size'--,
--sum(slope)
from group_trend
--join group_data on group_data.DatabaseName = group_trend.DatabaseName
join group_log on group_log.DatabaseName = group_trend.DatabaseName

--join get_capacity on get_capacity.
--group by group_trend.DatabaseName

--cross apply (select shortcut from get_capacity) g
--group by group_trend.DatabaseName --, g.shortcut

group by group_trend.DatabaseName 
)

*/

--insert into #Sum_by_database_name
--select * from #Sum_by_database_name
--group by DatabaseName 

/*
select 
--shortcut,
DatabaseName,
sum([Total Current Database Size]), 
sum([Total Projected Size]),
sum([Sum Log File Size (current)]), 
sum([Sum Total Projected Size])
 from #Sum_by_database_name
group by rollup(DatabaseName)

select 
sum([Total Current Database Size]) as [Total Current Database Size], 
sum([Total Projected Size]) as [Total Projected Size],
sum([Sum Log File Size (current)]) as [Sum Log File Size (current)], 
sum([Sum Total Projected Size]) as [Sum Total Projected Size]

from #Sum_by_database_name
;


with get_mount_point
as
(

select

sum([Total Current Database Size]) as [Total Current Database Size], 
sum([Total Projected Size]) as [Total Projected Size],
sum([Sum Log File Size (current)]) as [Sum Log File Size (current)], 
sum([Sum Total Projected Size]) as [Sum Total Projected Size]

from #Sum_by_database_name

)
--join get_capacity on 

--select * from  #Get_volume_mount_points

select --distinct
--volume_mount_point, shortcut, volume_id,
[Total Current Database Size], 
[Total Projected Size],
[Sum Log File Size (current)], 
[Sum Total Projected Size]--,
total_MB--,
--available_MB
from get_mount_point

*/



--cross apply (select volume_mount_point, shortcut, volume_id, total_MB, available_MB from get_capacity) g


--group by volume_mount_point, shortcut, volume_id

--g.volume_id

--SELECT db_name(database_id)
           -- FROM master.SYS.DATABASES


--select sum([Current Database Size]) as 'Total Current Database Size', 
--sum([Projected Size 12 Months (MB)]) as 'Total Projected Size',
--sum([Total Log File Size (current)]) as 'Sum Log File Size (current)', 
--sum([Total Projected Size]) as 'Sum Total Projected Size'
--from   projected_growth
--group by rollup(projected_growth.DatabaseName)








/*
with file_size as(
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
	--select * 
	from sys.master_files f
	join projected_growth on projected_growth
	/* temp db reflected inaccurately */
	

CROSS APPLY
    sys.dm_os_volume_stats(f.database_id, f.file_id)
	where name not like 'temp%'
) 


select * from file_size  




select volume_mount_point, shortcut, sum(DB_Size) as total_database_size_MB, sum('Projected Size 12 Months (MB)') as 'Projected Size', volume_id, total_MB, available_MB  from file_size
join projected_growth on file_size.DatabaseName = projected_growth.DatabaseName

group by volume_mount_point, shortcut, volume_id, total_MB, available_MB

*/





--/* now sum the trends and get current database size for each database */

--select group_with_rollup.DatabaseName, cast(c.[Database Size] as int) as 'Current Database Size', cast([Projected Size 12 Months (MB)] as int) as 'Projected Size 12 Months (MB)', 
--cast([Total Log File Size] as int) as 'Total Log File Size (current)', cast([Projected Size 12 Months (MB)] + [Total Log File Size] as int) as 'Total Projected Size'
--from group_with_rollup
--join c on c.DatabaseName = group_with_rollup.DatabaseName
--where MonthsAgo = 12
--order by DatabaseName, MonthsAgo


/*
select * from #trendlines
order by databasename
*/

