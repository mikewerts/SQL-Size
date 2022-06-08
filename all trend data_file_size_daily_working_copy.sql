drop table if exists #Last_12_Month_Backup
drop table if exists #Last_12_Month_Backup_unpivot
--drop table #Last_12_Month_Backup_trend
drop table if exists #Last_12_Month_Backup_trend_forecast
drop table if exists #trendlines
drop table if exists #CTE_AllIDs
drop table if exists #Sum_by_database_name
drop table if exists #Get_volume_mount_points
drop table if exists #Get_datafiles
drop table if exists #Get_logfiles
drop table if exists #Get_group_trend
drop table if exists #Get_group_trend_max
drop table if exists #Get_group_trend_next_six
drop table if exists #Get_group_trend_last_six
drop table if exists #Get_group_trend_last_12
drop table if exists #12_Month_Forecast
drop table if exists #12_Before_12_After
drop table if exists #get_database_new
drop table if exists #get_log_new
drop table if exists  #Last_12_Month_Log
drop table if exists  #12_Month_Forecast_log
drop table if exists #12_Before_12_After_log
drop table if exists #Last_12_Month_Backup_log_unpivot
drop table if exists #Last_12_Month_Backup_log_trend_forecast
drop table if exists #trendlines_log
drop table if exists #Get_datafiles
drop table if exists #Get_logfiles
drop table if exists #Get_group_log_trend
drop table if exists #latest_log_collection_date
drop table if exists #get_slope_for_collection_date_log
drop table if exists #get_slope_for_collection_date_data
drop table if exists #latest_data_collection_date
/* old */


SET ANSI_WARNINGS OFF
GO

Create table #Last_12_Month_Backup
(
[Endpoint] nvarchar(max)
--,[server_name] nvarchar(max)
--,[database_id] int
,[database_name] nvarchar(max)
    
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

--drop table #Last_12_Month_Log
Create table #Last_12_Month_Log
(
[Endpoint] nvarchar(max)
--,[server_name] nvarchar(max)
--,[database_id] int
,[database_name] nvarchar(max)
    
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

Create table #12_Month_Forecast
(
[Endpoint] nvarchar(max)
--,[server_name] nvarchar(max)
--,[database_id] int
,[database_name] nvarchar(max)
    
	,[13] NUMERIC(10, 1)
	,[14] NUMERIC(10, 1)
	,[15] NUMERIC(10, 1)
	,[16] NUMERIC(10, 1)
	,[17] NUMERIC(10, 1)
	,[18] NUMERIC(10, 1)
	,[19] NUMERIC(10, 1)
	,[20] NUMERIC(10, 1)
	,[21] NUMERIC(10, 1)
	,[22] NUMERIC(10, 1)
	,[23] NUMERIC(10, 1)
	,[24] NUMERIC(10, 1)
	--,[0] NUMERIC(10, 1)

)

Create table #12_Month_Forecast_log
(
[Endpoint] nvarchar(max)
--,[server_name] nvarchar(max)
--,[database_id] int
,[database_name] nvarchar(max)
    
	,[13] NUMERIC(10, 1)
	,[14] NUMERIC(10, 1)
	,[15] NUMERIC(10, 1)
	,[16] NUMERIC(10, 1)
	,[17] NUMERIC(10, 1)
	,[18] NUMERIC(10, 1)
	,[19] NUMERIC(10, 1)
	,[20] NUMERIC(10, 1)
	,[21] NUMERIC(10, 1)
	,[22] NUMERIC(10, 1)
	,[23] NUMERIC(10, 1)
	,[24] NUMERIC(10, 1)
	--,[0] NUMERIC(10, 1)

)

Create table #12_Before_12_After
(
[Endpoint] nvarchar(max)
--,[server_name] nvarchar(max)
--,[database_id] int
,[database_name] nvarchar(max)
    
	,[-11] NUMERIC(10, 1)
	,[-10] NUMERIC(10, 1)
	,[-9] NUMERIC(10, 1)
	,[-8] NUMERIC(10, 1)
	,[-7] NUMERIC(10, 1)
	,[-6] NUMERIC(10, 1)
	,[-5] NUMERIC(10, 1)
	,[-4] NUMERIC(10, 1)
	,[-3] NUMERIC(10, 1)
	,[-2] NUMERIC(10, 1)
	,[-1] NUMERIC(10, 1)
	,[0] NUMERIC(10, 1)
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


)

Create table #12_Before_12_After_log
(
[Endpoint] nvarchar(max)
--,[server_name] nvarchar(max)
--,[database_id] int
,[database_name] nvarchar(max)
    
	,[-11] NUMERIC(10, 1)
	,[-10] NUMERIC(10, 1)
	,[-9] NUMERIC(10, 1)
	,[-8] NUMERIC(10, 1)
	,[-7] NUMERIC(10, 1)
	,[-6] NUMERIC(10, 1)
	,[-5] NUMERIC(10, 1)
	,[-4] NUMERIC(10, 1)
	,[-3] NUMERIC(10, 1)
	,[-2] NUMERIC(10, 1)
	,[-1] NUMERIC(10, 1)
	,[0] NUMERIC(10, 1)
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


)



DECLARE @startDate DATETIME;
declare @servername nvarchar(max);
declare @databasename nvarchar(max);
declare @DatabaseName2 nvarchar(max);
declare @val as int;
set @val = 1


SET @startDate = GetDate();

--print @startDate

;with Last_12_Month_BU_Ave as 
(
SELECT [Endpoint]
      ,[database_name] 

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
	--,PVT.[0] as [0]
	--,-- as [0]
FROM (
SELECT [Endpoint]
      ,[server_name]
      ,[database_id]
    ,
	[database_name]
	  ,DATEDIFF(mm, @startDate, collection_date) AS MonthsAgo
	  ,CONVERT(NUMERIC(10, 1), AVG([database_size])) AS AvgSizeMB

  FROM [DBA].[dbo].[data_file_size_daily]

  group by [Endpoint]
      ,[server_name]
      ,[database_id]
      ,
	 [database_name]
	  ,DATEDIFF(mm, @startDate, collection_date)

    ) AS BCKSTAT
PIVOT(SUM(BCKSTAT.AvgSizeMB) FOR BCKSTAT.MonthsAgo IN (
 --      [-13]
	--, 
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
	--,[0]
            )) AS PVT
			
--ORDER BY PVT.DatabaseName
)


insert into #Last_12_Month_Backup	select *  from Last_12_Month_BU_Ave


--select * from #Last_12_Month_Backup
Create table #Last_12_Month_Backup_unpivot
(

MonthsAgo  int
,[Endpoint] nvarchar(max)
,[database_name] nvarchar(max)
,AvgSizeMB  decimal(9,2)
,trend DECIMAL(38, 10) default null
,slope decimal(9,2)

)
insert into #Last_12_Month_Backup_unpivot

select   MonthsAgo, [Endpoint]
      --,[server_name]
      --,[database_id]
      ,[database_name] , U.AvgSizeMB, null, null --, --as Average_Growth_MB  

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

--select * from #Last_12_Month_Backup_unpivot
--select * from #Last_12_Month_Backup 

/* new table with forecast */

Create table #Last_12_Month_Backup_trend_forecast
(

MonthsAgo  int
,[Endpoint] nvarchar(max)
--,[server_name] nvarchar(max)
--,[database_id] int
,[database_name] nvarchar(max)
 
,AvgSizeMB  decimal(9,2)
,Trend DECIMAL(38, 10) default null
,slope DECIMAL(38, 10)


)

/* Create table with sum by database name */

Create table #Sum_by_database_name
(
[Endpoint] nvarchar(max)
--,[server_name] nvarchar(max)
,[database_id] int
,[database_name] nvarchar(max)
 
,[volume_mount_point] nvarchar(512),
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
	[Endpoint] nvarchar(max)
,[database_name] nvarchar(max)
,[collection_date] date
	,[volume_mount_point] nvarchar(512)
	,[database_size] int
	,[available_MB] int
	,[total_MB] int
	 
)

Create table #Get_logfiles
(
	--[database_id] int
	[Endpoint] nvarchar(max)
	,[database_name] nvarchar(max)
	,[collection_date] date
	,[volume_mount_point] nvarchar(512)
	,[log_size] int
	,[available_MB] int
	,[total_MB] int
)

Create table #Get_group_trend

(
[Endpoint] nvarchar(max)
,[database_name] nvarchar(max)
,[database_size] int
,[collection_date] date
,[slope] decimal(9,2)


)

Create table #Get_group_log_trend

(
[Endpoint] nvarchar(max)
,[database_name] nvarchar(max)
,[database_size] int
,[collection_date] date
,[slope] decimal(9,2)


)


Create table #latest_log_collection_date

(
[Endpoint] nvarchar(max)
,[database_name] nvarchar(max)
,[collection_date] date

)

create table #get_slope_for_collection_date_log
(
[Endpoint] nvarchar(max)
,[database_name] nvarchar(max)
,[database_size] int
,[collection_date] date
,[slope] decimal(9,2)
)

Create table #latest_data_collection_date

(
[Endpoint] nvarchar(max)
,[database_name] nvarchar(max)
,[collection_date] date

)

create table #get_slope_for_collection_date_data
(
[Endpoint] nvarchar(max)
,[database_name] nvarchar(max)
,[database_size] int
,[collection_date] date
,[slope] decimal(9,2)
)



Create table #Get_group_trend_max

(
[Endpoint] nvarchar(max)
,[database_id] int,
[DatabaseName] nvarchar(max),
[Projected Size 12 Months (MB)] int,
[Slope] decimal(9,2)


)


Create table #Get_group_trend_next_six

(
[Endpoint] nvarchar(max)
,
[database_id] int,
[DatabaseName] nvarchar(max),
[Projected Size 12 Months (MB)] int,
[Slope] decimal(9,2)


)

Create table #Get_group_trend_last_six

(
[Endpoint] nvarchar(max)
,
[database_id] int,
[DatabaseName] nvarchar(max),
[Projected Size 12 Months (MB)] int,
[Slope] decimal(9,2)


)

Create table #Get_group_trend_last_12

(
[Endpoint] nvarchar(max)
,
[database_id] int,
[DatabaseName] nvarchar(max),
[Projected Size 12 Months (MB)] int,
[Slope] decimal(9,2)


)

 Create table #get_database_new
(
[Endpoint] nvarchar(max)
,DatabaseName nvarchar(max)
,[Size 12 Months Ago (MB)]  int
,[Size 6 Months Ago (MB)]  int
,[Database Size (MB)]  int
,[Projected Size 6 Months (MB)]  int
,[Projected Size 12 Months (MB)]  int


)

 Create table #get_log_new
(
[Endpoint] nvarchar(max)
,
DatabaseName nvarchar(max)
,[Log Size 12 Months Ago (MB)]  int
,[Log Size 6 Months Ago (MB)]  int
,[Log Size (MB)]  int
,[Projected Log Size 6 Months (MB)]  int
,[Projected Log Size 12 Months (MB)]  int

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
[endpoint] nvarchar(max),
[database_name] nvarchar(max),
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

/* next, declare cursor to calculate sample size and the different sums for each database */

	declare dbcursor cursor
	for 
	select [endpoint], [database_name] from #Last_12_Month_Backup 
	--where [server_name] = @servername
	 open  dbcursor  

	 fetch next from dbcursor
	 into @servername, @databasename

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
	where [database_name] = @databasename
	and [endpoint] = @servername

--where DatabaseName = 'Beacon'

	insert into #trendlines
	SELECT
	[endpoint] = @servername
	  ,[database_name] = @databasename
	  ,SampleSize   = @sample_size  
	 ,sumX    = @sumX   
	 ,sumY		=@sumY   
	 ,SumXX    = @sumXX   
	 ,SumYY    = @sumYY   
	 ,SumXY    = @sumXY



 -- calculate the slope and intercept
	SET @slope = --CASE WHEN @sample_size = 1
	case when (@sample_size * @sumXX - POWER(@sumX,2)) <= 0
		THEN 0 -- avoid divide by zero error
		ELSE (@sample_size * @sumXY - @sumX * @sumY) / (@sample_size * @sumXX - POWER(@sumX,2))
		END;
	SET @intercept = (@sumY - (@slope*@sumX)) / @sample_size;
--Now that we have found the slope and the intercept, we can easily calculate the linear trendline in each x-coordinate. We store the results in the temp table.

--declare @trend DECIMAL(38, 10)
	
/* calculate trend line */
	UPDATE #Last_12_Month_Backup_unpivot
	SET Trend = (@slope*MonthsAgo) + @intercept
	where [endpoint] = @servername and 
	[database_name] = @databasename;

	update #Last_12_Month_Backup_unpivot
	set slope = @slope
	where [endpoint] = @servername and 
	[database_name] = @databasename;

/* now calculate the forecast */

with butrend as 
(
SELECT
  --c.ID as 
  MonthsAgo
  ,[endpoint]
  ,[database_name]
 ,AvgSizeMB
 ,Trend
 ,slope
 
	FROM  #Last_12_Month_Backup_unpivot --#CTE_AllIDs   c 
	where [endpoint] = @servername and 
	[database_name] = @databasename
	--where DatabaseName = 'Beacon'
	),

joinbutrend as
(


	--insert into #Last_12_Month_Backup_trend_forecast
	select 
	c.ID as MonthsAgo
	,butrend.[endpoint]
	,butrend.[database_name]
	,butrend.AvgSizeMB
	,butrend.Trend
	,butrend.slope
		from #CTE_AllIDs c
		
		

		/* now outer join to calculate the forecast for 12 months out*/

	   left JOIN butrend ON c.ID = butrend.MonthsAgo	
	   
	   ) 

	   --select * from joinbutrend
	  

	 insert into #Last_12_Month_Backup_trend_forecast

	 
	   select joinbutrend.MonthsAgo - 12 as [month], @servername, @databasename, joinbutrend.AvgSizeMB, -- Trend, --from joinbutrend

	   Trend = Case when  joinbutrend.MonthsAgo <= (SELECT MAX(joinbutrend.MonthsAgo) from joinbutrend where [endpoint] = @servername and 
	[database_name] = @databasename)
        THEN joinbutrend.Trend
       
       WHEN joinbutrend.MonthsAgo > (SELECT MAX(joinbutrend.MonthsAgo) from joinbutrend where [endpoint]  = @servername and 
	[database_name] = @databasename)
        THEN (@slope * (MonthsAgo % 100)) + @intercept
      -- ELSE NULL
       END,
	   slope = 
	   /* slope = 0 set to 1 */
		case when ((@slope * (12 % 100)) + @intercept) = 0
		then 1

	    /* slope < 1 set to 1 */
	   when ((@slope * (24 % 100)) + @intercept) /((@slope * (12 % 100)) + @intercept) < 1
		then 1
	  /* slope > 1 */
	   else ((@slope * (24 % 100)) + @intercept) /((@slope * (12 % 100)) + @intercept)
	   end



		from joinbutrend

		


	FETCH NEXT from dbcursor into @servername, @databasename 

	 END   
CLOSE dbcursor;  
DEALLOCATE dbcursor;	



 /* pivot on DatabaseName to get trend */

 with db_trend
 as
 (
 SELECT 
 PVT.[endpoint] 
 ,PVT.[database_name]

	,PVT.[1] as [1]
	,PVT.[2] as [2]
	,PVT.[3] as [3]
	,PVT.[4] as [4]
	,PVT.[5] as [5]
	,PVT.[6] as [6]
	,PVT.[7] as [7]
	,PVT.[8] as [8]
	,PVT.[9] as [9]
	,PVT.[10] as [10]
	,PVT.[11] as [11]
	,PVT.[12] as [12]
	
FROM (


			select MonthsAgo, [endpoint] , [database_name], Trend  from #Last_12_Month_Backup_trend_forecast tf		
    GROUP BY tf.[endpoint], tf.[database_name], MonthsAgo, Trend
        --,DATEDIFF(mm, @startDate, BS.backup_start_date)
    ) AS BCKSTAT
PIVOT(sum(BCKSTAT.Trend) FOR BCKSTAT.MonthsAgo--, BCKSTAT.DatabaseName, BCKSTAT.Trend 
IN 

(

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
            )) AS PVT
--ORDER BY PVT.DatabaseName
)


insert into #12_Month_Forecast select * from db_trend

--select * from #12_Month_Forecast


--drop table #12_Before_12_After
insert into #12_Before_12_After 
select --L12.DatabaseName
L12.[Endpoint]
,L12.[database_name]
	,[1]
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
	,[13]  
	,[14] 
	,[15] 
	,[16] 
	,[17] 
	,[18] 
	,[19] 
	,[20] 
	,[21] 
	,[22] 
	,[23] 
	,[24] 



from #Last_12_Month_Backup L12
join #12_Month_Forecast N12
on (N12.[database_name] = L12.[database_name]
and N12.[Endpoint] = L12.[Endpoint])
;


--select * from #12_Before_12_After

/* now get the current size of the log files */

;with Last_12_Log_Ave as 
(
SELECT [Endpoint]

      ,[database_name] 

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
	--,PVT.[0] as [0]
	--,-- as [0]
FROM (

--SET @startDate = GetDate();
SELECT [Endpoint]
      ,[server_name]
      ,[database_id]
    ,
	[database_name]
	  ,DATEDIFF(mm, @startDate, collection_date) AS MonthsAgo
	  ,CONVERT(NUMERIC(10, 1), AVG([log_size])) AS AvgSizeMB
   FROM [DBA].[dbo].[log_file_size_daily]

  group by [Endpoint]
      ,[server_name]
      ,[database_id]
     -- ,[collection_date]
	, [database_name]
	  ,DATEDIFF(mm, @startDate, collection_date)

    ) AS BCKSTAT
PIVOT(SUM(BCKSTAT.AvgSizeMB) FOR BCKSTAT.MonthsAgo IN (
 --      [-13]
	--, 
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
	--,[0]
            )) AS PVT
			
--ORDER BY PVT.DatabaseName
)


insert into #Last_12_Month_Log select * from Last_12_Log_Ave 

--select * from #Last_12_Month_Log





Create table #Last_12_Month_Backup_log_unpivot
(

MonthsAgo  int
,[Endpoint] nvarchar(max)
--,[server_name] nvarchar(max)
--,[database_id] int
,[database_name] nvarchar(max)
,AvgSizeMB  decimal(9,2)
,trend DECIMAL(38, 10) default null
,slope decimal(9,2)

)



insert into #Last_12_Month_Backup_log_unpivot

select   MonthsAgo, [Endpoint]
      --,[server_name]
      --,[database_id]
      ,[database_name] , U.AvgSizeMB, null, null --, --as Average_Growth_MB  

	from #Last_12_Month_Log
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

--select * from #Last_12_Month_Backup_log_unpivot

Create table #Last_12_Month_Backup_log_trend_forecast
(

MonthsAgo  int
,[Endpoint] nvarchar(max)
--,[server_name] nvarchar(max)
--,[database_id] int
,[database_name] nvarchar(max)
 
,AvgSizeMB  decimal(9,2)
,Trend DECIMAL(38, 10) default null
,slope DECIMAL(38, 10)


)

create table #trendlines_log 
(
[endpoint] nvarchar(max),
[database_name] nvarchar(max),
SampleSize INT, 
sumX   DECIMAL(38, 10),
sumY   DECIMAL(38, 10),
sumXX   DECIMAL(38, 10),
sumYY   DECIMAL(38, 10),
sumXY   DECIMAL(38, 10),
--trend DECIMAL(38, 10)
);

/* next, declare cursor to calculate sample size and the different sums for each database */

	declare logcursor cursor
	for 
	select [endpoint], [database_name] from #Last_12_Month_Log 
	--where [server_name] = @servername
	 open  logcursor  

	 fetch next from logcursor
	 into @servername, @databasename

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
	FROM #Last_12_Month_Backup_log_unpivot
	where [database_name] = @databasename
	and [endpoint] = @servername

	insert into #trendlines_log 
	SELECT
	[endpoint] = @servername
	  ,[database_name] = @databasename
	  ,SampleSize   = @sample_size  
	 ,sumX    = @sumX   
	 ,sumY		=@sumY   
	 ,SumXX    = @sumXX   
	 ,SumYY    = @sumYY   
	 ,SumXY    = @sumXY

/* divide by zero error */
	/* test divisor */
	--print 'Sample Size: ' + cast(@sample_size as nvarchar)
	--print '@sumXY: ' + cast(@sumXY as nvarchar)
	--print '@sumX: ' + cast(@sumX as nvarchar)
	--print '@sumY: ' + cast(@sumY as nvarchar)
	--print '@sumXX: ' + cast(@sumXX as nvarchar)
	--print '@sumX: ' + cast(@sumX as nvarchar)
	--print 'POWER(@sumX,2): ' + cast(POWER(@sumX,2) as nvarchar)
	--print 'Numerator: ' + cast( (@sample_size * @sumXY - @sumX * @sumY)as nvarchar)
	--print 'Denominator: ' +cast((@sample_size * @sumXX - POWER(@sumX,2)) as nvarchar)


 -- calculate the slope and intercept
	SET @slope = --CASE WHEN @sample_size = 1
	case when (@sample_size * @sumXX - POWER(@sumX,2)) <=0
		THEN 0 -- avoid divide by zero error
		ELSE (@sample_size * @sumXY - @sumX * @sumY) / (@sample_size * @sumXX - POWER(@sumX,2))
		END;
	SET @intercept = (@sumY - (@slope*@sumX)) / @sample_size;


--Now that we have found the slope and the intercept, we can easily calculate the linear trendline in each x-coordinate. We store the results in the temp table.

--declare @trend DECIMAL(38, 10)
	
/* calculate trend line */
	UPDATE #Last_12_Month_Backup_log_unpivot
	SET Trend = (@slope*MonthsAgo) + @intercept
	where [endpoint] = @servername and 
	[database_name] = @databasename;

	update #Last_12_Month_Backup_log_unpivot
	set slope = @slope
	where [endpoint] = @servername and 
	[database_name] = @databasename;

/* now calculate the forecast */

with butrend_log as 
(
SELECT
  --c.ID as 
  MonthsAgo
  ,[endpoint]
  ,[database_name]
 ,AvgSizeMB
 ,Trend
 ,slope
 
	FROM  #Last_12_Month_Backup_log_unpivot --#CTE_AllIDs   c 
	where [endpoint] = @servername and 
	[database_name] = @databasename
	--where DatabaseName = 'Beacon'
	),

joinbutrend_log as
(
	select 
	c.ID as MonthsAgo
	,butrend_log.[endpoint]
	,butrend_log.[database_name]
	,butrend_log.AvgSizeMB
	,butrend_log.Trend
	,butrend_log.slope
		from #CTE_AllIDs c
		
		

		/* now outer join to calculate the forecast for 12 months out*/

	   left JOIN butrend_log ON c.ID = butrend_log.MonthsAgo	
	  
	   ) 
	 insert into #Last_12_Month_Backup_log_trend_forecast

	 
	   select joinbutrend_log.MonthsAgo - 12 as [month], @servername, @databasename, joinbutrend_log.AvgSizeMB, -- Trend, --from joinbutrend

	   Trend = Case when  joinbutrend_log.MonthsAgo <= (SELECT MAX(joinbutrend_log.MonthsAgo) from joinbutrend_log where [endpoint] = @servername and 
	[database_name] = @databasename)
        THEN joinbutrend_log.Trend
       
       WHEN joinbutrend_log.MonthsAgo > (SELECT MAX(joinbutrend_log.MonthsAgo) from joinbutrend_log where [endpoint]  = @servername and 
	[database_name] = @databasename)
        THEN (@slope * (MonthsAgo % 100)) + @intercept
      -- ELSE NULL
       END,
	   slope = 
	    /* slope = 0 set to 1 */
		case when ((@slope * (12 % 100)) + @intercept) = 0
		then 1
		 /* slope < 1 set to 1 */
	    when ((@slope * (24 % 100)) + @intercept) /((@slope * (12 % 100)) + @intercept) < 1
		then 1
	  /* slope > 1 */
	   else ((@slope * (24 % 100)) + @intercept) /((@slope * (12 % 100)) + @intercept)
	   end

		from joinbutrend_log

	FETCH NEXT from logcursor into @servername, @databasename 

	 END   
CLOSE logcursor;  
DEALLOCATE logcursor;	

--select * from #Last_12_Month_Backup_log_trend_forecast

/* log trend */

/* pivot on DatabaseName to get trend */

 ;with log_trend
 as
 (
 SELECT 
 PVT.[endpoint] 
 ,PVT.[database_name]
	,PVT.[1] as [1]
	,PVT.[2] as [2]
	,PVT.[3] as [3]
	,PVT.[4] as [4]
	,PVT.[5] as [5]
	,PVT.[6] as [6]
	,PVT.[7] as [7]
	,PVT.[8] as [8]
	,PVT.[9] as [9]
	,PVT.[10] as [10]
	,PVT.[11] as [11]
	,PVT.[12] as [12]
	
FROM (


			select MonthsAgo, [endpoint] , [database_name], Trend  from #Last_12_Month_Backup_log_trend_forecast tf		
    GROUP BY tf.[endpoint], tf.[database_name], MonthsAgo, Trend
        --,DATEDIFF(mm, @startDate, BS.backup_start_date)
    ) AS BCKSTAT
PIVOT(sum(BCKSTAT.Trend) FOR BCKSTAT.MonthsAgo--, BCKSTAT.DatabaseName, BCKSTAT.Trend 
IN 
--PIVOT(0) FOR BCKSTAT.MonthsAgo IN 
(

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
            )) AS PVT
--ORDER BY PVT.DatabaseName
)

--select * from log_trend

insert into #12_Month_Forecast_log select * from log_trend



;with log_files as(

SELECT
[Endpoint]
,[database_name]
,[collection_date]
,[volume_mount_point] 
,[log_size] 
,[available_MB]
,[total_MB]
	 
 FROM [DBA].[dbo].[log_file_size_daily]

  )
-- select * from log_files

insert into #Get_logfiles
select * from log_files

--select * from #Get_logfiles
--where [Endpoint] = 'DEV-ITSQL-01\compx'
--and database_name = 'SBX_MEMIC_WCX_STAGING'


;with group_log_trend as(
select 
bltf.[Endpoint]
,bltf.[database_name]
,l.[log_size]
,l.collection_date
,bltf.slope 

from #Last_12_Month_Backup_log_trend_forecast bltf
join #Get_logfiles l on l.[database_name] = bltf.[database_name] and l.[Endpoint] = bltf.[Endpoint]
where bltf.MonthsAgo = 12


)

insert into #Get_group_log_trend
select * from group_log_trend

--select * from #Get_group_log_trend

/* now get the latest collection date */

;with latest_log_collection_date as
(
select [Endpoint]
,[database_name]
,MAX([collection_date]) as [collection_date]


 from #Get_group_log_trend
 group by 
[Endpoint]
,[database_name]
)

/* get the latest log collection date from each database and most recent collected size */

insert into #latest_log_collection_date
select * from latest_log_collection_date
order by collection_date desc

--select * from #latest_log_collection_date

;with get_slope_for_collection_date_log
as
(
/* select distinct endpoint for clustered instances */
select distinct llcd.[Endpoint]
,llcd.[database_name]
,ggt.[database_size]
,llcd.[collection_date]
,ggt.[slope]

from #latest_log_collection_date llcd
join #Get_group_log_trend ggt
on llcd.[database_name] = ggt.[database_name] and llcd.Endpoint = ggt.Endpoint and llcd.collection_date = ggt.collection_date

)

insert into #get_slope_for_collection_date_log
select * from get_slope_for_collection_date_log




insert into #12_Before_12_After_log 
select --L12.DatabaseName
L12.[Endpoint]
,L12.[database_name]
	,[1]
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
	,[13]  
	,[14] 
	,[15] 
	,[16] 
	,[17] 
	,[18] 
	,[19] 
	,[20] 
	,[21] 
	,[22] 
	,[23] 
	,[24] 



from #Last_12_Month_log L12
join #12_Month_Forecast_log N12
on (N12.[database_name] = L12.[database_name]
and N12.[Endpoint] = L12.[Endpoint])
;



  /* now get the data files */

   
;with data_files as(

SELECT
[Endpoint]
,[database_name]
,[collection_date]
,[volume_mount_point] 
,[database_size] 
,[available_MB]
,[total_MB]
	 
 FROM [DBA].[dbo].[data_file_size_daily]

  )



insert into #Get_datafiles
select * from data_files;

--select * from #Get_datafiles;


;with group_trend as(
select 
btf.[Endpoint]
,btf.[database_name]
,s.[database_size]
,s.[collection_date]
--,btf.MonthsAgo
,btf.slope 

from #Last_12_Month_Backup_trend_forecast btf
join #Get_datafiles s on s.[database_name] = btf.[database_name] and s.[Endpoint] = btf.[Endpoint]
where btf.MonthsAgo = 12
)

insert into #Get_group_trend
select * from group_trend -- where MonthsAgo = 12

--select * from #Get_group_trend

/* now get the latest collection date */

;with latest_data_collection_date as
(
select [Endpoint]
,[database_name]
,MAX([collection_date]) as [collection_date]
 from #Get_group_trend
 group by 
[Endpoint]
,[database_name]
)

/* get the latest log collection date from each database and most recent collected size */

insert into #latest_data_collection_date
select * from latest_data_collection_date
order by collection_date desc

;with get_slope_for_collection_date_data
as
(
/* select distinct endpoint for clustered instances */
select distinct ldcd.[Endpoint]
,ldcd.[database_name]
,ggt.[database_size]
,ldcd.[collection_date]
,ggt.[slope]

from #latest_data_collection_date ldcd
join #Get_group_trend ggt
on ldcd.[database_name] = ggt.[database_name] and ldcd.Endpoint = ggt.Endpoint and ldcd.collection_date = ggt.collection_date

)

insert into #get_slope_for_collection_date_data
select * from get_slope_for_collection_date_data


--select * from #Get_group_trend

;with get_database_new as(
  select 
  [12ba].[Endpoint]
  ,[12ba].[database_name]
 ,max([12ba].[-11]) as 'Size 12 Months Ago (MB)'
  ,max([12ba].[-5]) as 'Size 6 Months Ago (MB)'
  ,max(gsfcdd.database_size) as 'Current Size (MB)'

 
 	/* trendline lags behind current DB size */

	,case when (max([12ba].[0]) < max(gsfcdd.database_size))
	/* trendline lags behind current DB size */
	then max(cast((gsfcdd.database_size) * (1 + (gsfcdd.slope -1) /2) as int))
	when (max([12ba].[6]) < 0)
	/* factor negative size */
	then max(gsfcdd.database_size)
	else 
	/* use trendline */
	max(cast([12ba].[6] as int))
	end
	as 'Projected Size 6 Months (MB)', 
	
	/* get projected size 12 months */
	case when (max([12ba].[0]) < max(gsfcdd.database_size))
	/* trendline lags behind current DB size */
	then max(cast((gsfcdd.database_size) * gsfcdd.slope as int))
	/* factor negative size */
	when (max([12ba].[12]) < 0) and (max([12ba].[6]) < 0)
	/* both projected values less than zero, use current value */
	then max(gsfcdd.database_size)
	when (max([12ba].[12]) < 0) and (max([12ba].[6]) > 0)
	/* use last projected positive value */
	then max([12ba].[6])
	else 
	/* use trendline */
	cast(max([12ba].[12]) as int)
	end as 'Projected Size 12 Months (MB)'

 
  from #12_Before_12_After [12ba]
  
   join #get_slope_for_collection_date_data gsfcdd on 
  gsfcdd.[Endpoint] = [12ba].[Endpoint] and
  gsfcdd.[database_name] = [12ba].[database_name]

  group by [12ba].[Endpoint],
  [12ba].[database_name]
  )
 
 --select *  from get_database_new

 
 -- order by databasename;
   
 insert into #get_database_new select *  from get_database_new

 --select * from #get_database_new



 ;with get_log_new as(
  select 
  [12ba].[Endpoint]
  ,[12ba].[database_name]
 ,max([12ba].[-11]) as 'Size 12 Months Ago (MB)'
  ,max([12ba].[-5]) as 'Size 6 Months Ago (MB)'
  ,max(gsfcdl.database_size) as 'Current Size (MB)'
 -- ,MAX(gsfcdl.[collection_date]) as 'Collection Date'
 -- ,max([12ba].[0]) as 'Trendline Size'
 -- ,MAX(gsfcdl.slope) as 'Slope'
  
	,case when (max([12ba].[0]) < max(gsfcdl.database_size)) 
	/* trendline lags behind current DB size */
	then max(cast((gsfcdl.database_size) * (1 + (gsfcdl.slope -1) /2) as int))
	when (max([12ba].[6]) < 0)
	/* factor negative size */
	then max(gsfcdl.database_size)
	else 
	/* use trendline */
	max(cast([12ba].[6] as int))
	end
	as 'Projected Size 6 Months (MB)', 
	
	/* get projected size 12 months */
	case when (max([12ba].[0]) < max(gsfcdl.database_size)) 
	/* trendline lags behind current DB size */
	then max(cast((gsfcdl.database_size) * gsfcdl.slope as int))
	/* factor negative size */
	when (max([12ba].[12]) < 0) and (max([12ba].[6]) < 0)
	/* both projected values less than zero, use current value */
	then max(gsfcdl.database_size)
	when (max([12ba].[12]) < 0) and (max([12ba].[6]) > 0)
	/* use last projected positive value */
	then max([12ba].[6])
	else 
	/* use trendline */
	cast(max([12ba].[12]) as int)
	end as 'Projected Size 12 Months (MB)'

 
  from #12_Before_12_After_log [12ba]

  join #get_slope_for_collection_date_log gsfcdl on 
  gsfcdl.[Endpoint] = [12ba].[Endpoint] and
  gsfcdl.[database_name] = [12ba].[database_name]  

  group by [12ba].[Endpoint],
  [12ba].[database_name]
  )

 insert into #get_log_new 
 
 select  *  from get_log_new 

 --select * from #get_log_new gln 

/* new join MJW 2-16-22 */

  select gdn.[Endpoint] 
,
gdn.[DatabaseName] 
,[Size 12 Months Ago (MB)] 
,[Size 6 Months Ago (MB)]
,[Database Size (MB)]  
,[Projected Size 6 Months (MB)]  
,[Projected Size 12 Months (MB)]  
,[Log Size 12 Months Ago (MB)]
,[Log Size 6 Months Ago (MB)]
,[Log Size (MB)]
,[Projected Log Size 6 Months (MB)]
,[Projected Log Size 12 Months (MB)]

from #get_log_new gln


join #get_database_new gdn on gdn.[Endpoint] = gln.[Endpoint] and gdn.DatabaseName = gln.DatabaseName

-- where  gdn.[Endpoint]  = 'UAT-SQLCOMPX'

 --  and gdn.[DatabaseName] = 'UAT_WCXP'

 /*  ---------------- end working section -------------------------  */