

drop table #tmpTableSizes


CREATE TABLE #tmpTableSizes
(
    tableName varchar(100),
    numberofRows varchar(100),
    reservedSize varchar(50),
    dataSize varchar(50),
    indexSize varchar(50),
    unusedSize varchar(50)
)
insert #tmpTableSizes
EXEC sp_MSforeachtable @command1="EXEC sp_spaceused '?'"

/* sum of data sizes per database */

select * from #tmpTableSizes

select   --tableName ,
   --  sum(numberofRows),
   -- cast(convert(numeric, ((left(reservedSize, (len(reservedSize) - 3)))))/1000 as decimal (8,4)) --,
   --db_id,
   --sum(numberofRows),
   sum(isnull(convert(decimal, (numberofRows)), 0)) 'Total Rows',

	
	isnull(convert(decimal(8,4), (convert(decimal, (sum(((left(reservedSize, (len(reservedSize) - 3)))*8))))/1024000)), 0) 'sumReservedSize',
	isnull(convert(decimal(8,4), (convert(decimal, (sum(((left(dataSize, (len(dataSize) - 3)))*8))))/1024000)), 0) 'sumDataSize',
	isnull(convert(decimal(8,4), (convert(decimal, (sum(((left(indexSize, (len(indexSize) - 3)))*8))))/1024000)), 0) 'sumindexSize',
	isnull(convert(decimal(8,4), (convert(decimal, (sum(((left(unusedSize, (len(unusedSize) - 3)))*8))))/1024000)), 0) 'sumUnusedSize'
	
	

 --  isnull(sum(convert(decimal(8,4), numberofRows)), 0)   ,
  /* 
   isnull(convert(decimal(8,4), (convert(decimal, (sum((dataSize*8))))/1024000)), 0)   ,
   isnull(convert(decimal(8,4), (convert(decimal, (sum((indexSize*8))))/1024000)), 0)  ,
   isnull(convert(decimal(8,4), (convert(decimal, (sum((unusedSize*8))))/1024000)), 0)  
	*/
--	, reservedSize
	from #tmpTableSizes
--order by cast(LEFT(reservedSize, LEN(reservedSize) - 4) as int)  desc


---select * from #tmpTableSizes