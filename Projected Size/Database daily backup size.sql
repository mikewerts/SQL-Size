    DECLARE @startDate DATETIME;
declare @databasename nvarchar(max);
declare @DatabaseName2 nvarchar(max);
declare @val as int;
set @val = 1

SET @startDate = GetDate();
	
	SELECT --BS.*, BF.*, 
	BS.database_name AS DatabaseName
  -- ,DATEDIFF(mm, @startDate, BS.backup_start_date) AS MonthsAgo
  ,BS.backup_start_date
   --     ,CONVERT(NUMERIC(10, 1), AVG(BF.file_size / 1048576.0)) AS AvgSizeMB
  -- ,CONVERT(NUMERIC(10, 1), AVG(BS.backup_size / 1048576.0)) AS AvgSizeMB

   ,BS.backup_size / 1048576.0 as BackupSizeMB
   ,BF.[file_type]
    FROM msdb.dbo.backupset AS BS
    INNER JOIN msdb.dbo.backupfile AS BF ON BS.backup_set_id = BF.backup_set_id
    WHERE BS.database_name 
	
	NOT IN (
            'master'
            ,'msdb'
            ,'model'
            ,'tempdb'
            )

--		 = 'ExecutiveReporting'
        AND BS.database_name IN (
            SELECT db_name(database_id)
            FROM master.SYS.DATABASES
            WHERE state_desc = 'ONLINE'
            )
        AND BF.[file_type] = --'L' 
		'D' --for databases
		and BS.type = 'D'
       AND BS.backup_start_date BETWEEN DATEADD(yy, - 1, @startDate)
          AND @startDate

		  order by BS.backup_start_date desc
   -- GROUP BY BS.database_name
   --    ,DATEDIFF(mm, @startDate, BS.backup_start_date)