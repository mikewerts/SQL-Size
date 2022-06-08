/*
Create table #Last_12_Month_Backup
(
DatabaseName nvarchar(max)
    
,[-12] NUMERIC(10, 1)
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

)
*/


DECLARE @startDate DATETIME;

SET @startDate = GetDate();

--insert into #Last_12_Month_Backup



with Last_12_Month_BU_Ave as 
(
SELECT PVT.DatabaseName as DatabaseName 
,PVT.[-12] - PVT.[-13] as [-13]   
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
	--,-- as [0]
FROM (
    SELECT BS.database_name AS DatabaseName
   ,DATEDIFF(mm, @startDate, BS.backup_start_date) AS MonthsAgo
        ,CONVERT(NUMERIC(10, 1), AVG(BF.file_size / 1048576.0)) AS AvgSizeMB
    FROM msdb.dbo.backupset AS BS
    INNER JOIN msdb.dbo.backupfile AS BF ON BS.backup_set_id = BF.backup_set_id
    WHERE BS.database_name NOT IN (
            'master'
            ,'msdb'
            ,'model'
            ,'tempdb'
            )
		 --= 'IRDW'
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
         [-13]
		   ,[-12]
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
),



--select  DatabaseName 
    
--, avg (isnull([-13],0) + isnull([-12],0) + isnull([-11],0) + isnull([-10],0))
	--,[-12]
	--,[-11]
	--,[-10]
	--,[-9]
	--,[-8]
	--,[-7]
	--,[-6]
	--,[-5]
	--,[-4]
	--,[-3]
	--,[-2]
	--,[-1]
	--,[0]
	--,AVG(case when [-13] is not null then [-13]

	--   + case when [-12] is not null then [-12] )


monthly_diff as (
select  DatabaseName, U.AvgSizeMB as Average_Growth_MB  

	from Last_12_Month_BU_Ave
	unpivot (AvgSizeMB  FOR MonthsAgo IN
	(
	           --[-13]
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
	))
	as u) 
	select DatabaseName, avg(Average_Growth_MB) as Average_Growth_Month_MB
from monthly_diff
	group by DatabaseName
	
	
	--where 

	--group BY DatabaseName --, [-13]

	