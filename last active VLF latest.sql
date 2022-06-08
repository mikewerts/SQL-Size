--USE AdventureWorks2016
--GO

--if exists (select ##freeloginfotable  
if object_id('tempdb..##freeloginfotable') is not null drop table ##freeloginfotable
create table ##freeloginfotable
(
/*
RecoveryUnitId	int,
FileId	smallint,
FileSize	bigint,
StartOffset	float,
FSeqNo	bigint,
Status	int,
Parity	tinyint,
CreateLSN nvarchar(48)
*/
[Database Name] nvarchar(max),
free_mb_after_active_log decimal(9,2),
vlf_count int, 
min_vlf_active int, 
ordinal_min_vlf_active int,
max_vlf_active int,
ordinal_max_vlf_active int,
free_log_pct_before_active_log decimal(9,4),
active_log_pct decimal(9,4),
free_log_pct_after_active_log decimal(9,4)
)
declare @sql nvarchar(max)
set @sql = 'IF ''?'' NOT IN(''master'', ''model'', ''msdb'', ''tempdb'') 
/* exclude Rubrik mount point databases */
and ''?''  IN(
select  s.name as databasename
 from sys.master_files m
join sys.databases s
on s.database_id = m.database_id
where type = 1 
and SUBSTRING(m.physical_name, 1, 1) <> ''\''
)

BEGIN USE ?

declare @datbasename nvarchar(48);
set @datbasename = ''[?]''



;WITH cte_vlf AS (
SELECT ROW_NUMBER() OVER(ORDER BY vlf_begin_offset) AS vlfid, DB_NAME(database_id) AS [Database Name], vlf_sequence_number, vlf_active, vlf_begin_offset, vlf_size_mb
	FROM sys.dm_db_log_info(DEFAULT)),
cte_vlf_cnt AS (SELECT [Database Name], COUNT(vlf_sequence_number) AS vlf_count,
	(SELECT COUNT(vlf_sequence_number) FROM cte_vlf WHERE vlf_active = 0) AS vlf_count_inactive,
	(SELECT COUNT(vlf_sequence_number) FROM cte_vlf WHERE vlf_active = 1) AS vlf_count_active,
	(SELECT MIN(vlfid) FROM cte_vlf WHERE vlf_active = 1) AS ordinal_min_vlf_active,
	(SELECT MIN(vlf_sequence_number) FROM cte_vlf WHERE vlf_active = 1) AS min_vlf_active,
	(SELECT MAX(vlfid) FROM cte_vlf WHERE vlf_active = 1) AS ordinal_max_vlf_active,
	(SELECT MAX(vlf_sequence_number) FROM cte_vlf WHERE vlf_active = 1) AS max_vlf_active,
	sum(vlf_size_mb) as size_mb
	FROM cte_vlf
	GROUP BY [Database Name])


insert into ##freeloginfotable SELECT @datbasename, 

convert(numeric(9,2),(cast (vlf_count as decimal(9,2)) -  cast (ordinal_max_vlf_active as decimal(9,2)))/cast (vlf_count as decimal(9,2)) * cast( size_mb as decimal (9,2))) 
as free_mb_after_active_log,
vlf_count, min_vlf_active, ordinal_min_vlf_active, max_vlf_active, ordinal_max_vlf_active,
((ordinal_min_vlf_active-1)*100.00/vlf_count) AS free_log_pct_before_active_log,

((ordinal_max_vlf_active-(ordinal_min_vlf_active-1))*100.00/vlf_count) AS active_log_pct,
((vlf_count-ordinal_max_vlf_active)*100.00/vlf_count) AS free_log_pct_after_active_log

FROM cte_vlf_cnt
END
'


exec sp_msforEachDB @sql

select * from ##freeloginfotable order by free_mb_after_active_log desc 