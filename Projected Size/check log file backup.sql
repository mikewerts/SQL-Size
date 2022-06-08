USE msdb

SELECT  [database_name] AS [Database] ,

        DATEPART(MONTH, [backup_start_date]) AS [Month] ,

        AVG([backup_size] / 1024 / 1024) AS [Backup Size MB]

FROM    msdb.dbo.backupset

WHERE   [type] = 'L'

        AND [backup_start_date] >= '2020-01-01'

GROUP BY [database_name] ,

        DATEPART(MONTH, [backup_start_date])

ORDER BY DATEPART(MONTH, [backup_start_date]) ,

        database_name;

SELECT  [database_name] AS [Database] ,

        DATEPART(DAY, [backup_start_date]) AS [Day] ,

        AVG([backup_size] / 1024 / 1024) AS [Backup Size MB]

FROM    msdb.dbo.backupset

WHERE   [type] = 'L'

        AND [backup_start_date] >= '2020-01-01'

GROUP BY [database_name] ,

        DATEPART(DAY, [backup_start_date])

ORDER BY database_name ,

        DATEPART(DAY, [backup_start_date]);

SELECT  [database_name] AS [Database] ,

        DATEPART(WEEK, [backup_start_date]) AS [Week] ,

        AVG([backup_size] / 1024 / 1024) AS [Backup Size MB]

FROM    msdb.dbo.backupset

WHERE   [type] = 'L'

        AND [backup_start_date] >= '2020-01-01'

GROUP BY [database_name] ,

        DATEPART(WEEK, [backup_start_date])

ORDER BY database_name ,

        DATEPART(WEEK, [backup_start_date]);