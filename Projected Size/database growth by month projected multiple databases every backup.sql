


	DECLARE @startDate DATETIME;
	SET @startDate = GetDate();

	    SELECT BS.database_name AS DatabaseName
		,BS.backup_start_date
   --,DATEDIFF(mm, @startDate, BS.backup_start_date) AS MonthsAgo
   --     ,CONVERT(NUMERIC(10, 1), AVG(BF.file_size / 1048576.0)) AS AvgSizeMB
  -- ,CONVERT(NUMERIC(10, 1), AVG(BS.backup_size / 1048576.0)) AS AvgSizeMB
  ,CONVERT(NUMERIC(10, 1), (BS.backup_size / 1048576.0)) AS AvgSizeMB
    FROM msdb.dbo.backupset AS BS
    INNER JOIN msdb.dbo.backupfile AS BF ON BS.backup_set_id = BF.backup_set_id
 --   WHERE BS.database_name 
	--= 'ExecutiveReporting'
	
	--NOT IN (
 --           'master'
 --           ,'msdb'
 --           ,'model'
 --           ,'tempdb'
 --           )

		 --= 'Beacon'
        AND BS.database_name IN (
            SELECT db_name(database_id)
            FROM master.SYS.DATABASES
            WHERE state_desc = 'ONLINE'
	--		and BS.database_name 
	--= 'ExecutiveReporting'
          )
        AND BF.[file_type] = --'L' 
		'D' --for databases
       AND BS.backup_start_date BETWEEN DATEADD(yy, - 1, @startDate)
          AND @startDate
   -- GROUP BY BS.database_name