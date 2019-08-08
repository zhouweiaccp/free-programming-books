
drop index dms_fileVerGuid.ix_clu_fordms_fileVerGuid_file_verId;
create    index ix_clu_fordms_fileVerGuid_file_verId on dms_fileVerGuid(file_verId);

--删除主键
alter table 表名 drop constraint 主键名
--添加主键
--alter table 表名 add constraint 主键名 primary key(字段名1,字段名2……)

alter table [dms_instanceCfg125] add   CONSTRAINT [PK_DMS_INSTANCECFG125] PRIMARY KEY CLUSTERED 
(
	[instance_id] ASC,
	[cfg_name] ASC
)

--https://docs.microsoft.com/zh-cn/sql/t-sql/database-console-commands/dbcc-indexdefrag-transact-sql?view=sql-server-2017

--DBCC SHOWCONTIG来确定是否需要重构表的索引  https://www.cnblogs.com/bluedy1229/p/3227167.html
dbcc showcontig(dms_file)

---重建索引
Select 'DBCC INDEXDEFRAG ('+DB_Name()+','+Object_Name(ID)+','+Cast(INDID As Varchar)+')'+Char(10)
From SysIndexes
Where ID Not IN (Select ID From SYSObjects Where xType='S')
 
--A. 使用 DBCC INDEXDEFRAG 对索引进行碎片整  理以下示例对 AdventureWorks2008R2 数据库的 Production.Product 表中的 PK_Product_ProductID 索引的所有分区进行碎片整理。
--https://blog.csdn.net/luoyanqing119/article/details/17577313
DBCC INDEXDEFRAG (AdventureWorks2008R2, "Production.Product", PK_Product_ProductID)
GO


-- B. 使用 DBCC SHOWCONTIG 和 DBCC INDEXDEFRAG 对数据库中的索引进行碎片整理
-- 以下示例将展示一种简单的方法，该方法可用于对数据库中碎片数量在声明的阈值之上的所有索引进行碎片整理。
/*Perform a 'USE <database name>' to select the database in which to run the script.*/
-- Declare variables
SET NOCOUNT ON;
DECLARE @tablename varchar(255);
DECLARE @execstr   varchar(400);
DECLARE @objectid  int;
DECLARE @indexid   int;
DECLARE @frag      decimal;
DECLARE @maxfrag   decimal;

-- Decide on the maximum fragmentation to allow for.
SELECT @maxfrag = 30.0;

-- Declare a cursor.
DECLARE tables CURSOR FOR
   SELECT TABLE_SCHEMA + '.' + TABLE_NAME
   FROM INFORMATION_SCHEMA.TABLES
   WHERE TABLE_TYPE = 'BASE TABLE';

-- Create the table.
CREATE TABLE #fraglist (
   ObjectName char(255),
   ObjectId int,
   IndexName char(255),
   IndexId int,
   Lvl int,
   CountPages int,
   CountRows int,
   MinRecSize int,
   MaxRecSize int,
   AvgRecSize int,
   ForRecCount int,
   Extents int,
   ExtentSwitches int,
   AvgFreeBytes int,
   AvgPageDensity int,
   ScanDensity decimal,
   BestCount int,
   ActualCount int,
   LogicalFrag decimal,
   ExtentFrag decimal);

-- Open the cursor.
OPEN tables;

-- Loop through all the tables in the database.
FETCH NEXT
   FROM tables
   INTO @tablename;

WHILE @@FETCH_STATUS = 0
BEGIN
-- Do the showcontig of all indexes of the table
   INSERT INTO #fraglist 
   EXEC ('DBCC SHOWCONTIG (''' + @tablename + ''') 
      WITH FAST, TABLERESULTS, ALL_INDEXES, NO_INFOMSGS');
   FETCH NEXT
      FROM tables
      INTO @tablename;
END;

-- Close and deallocate the cursor.
CLOSE tables;
DEALLOCATE tables;

-- Declare the cursor for the list of indexes to be defragged.
DECLARE indexes CURSOR FOR
   SELECT ObjectName, ObjectId, IndexId, LogicalFrag
   FROM #fraglist
   WHERE LogicalFrag >= @maxfrag
      AND INDEXPROPERTY (ObjectId, IndexName, 'IndexDepth') > 0;

-- Open the cursor.
OPEN indexes;

-- Loop through the indexes.
FETCH NEXT
   FROM indexes
   INTO @tablename, @objectid, @indexid, @frag;

WHILE @@FETCH_STATUS = 0
BEGIN
   PRINT 'Executing DBCC INDEXDEFRAG (0, ' + RTRIM(@tablename) + ',
      ' + RTRIM(@indexid) + ') - fragmentation currently '
       + RTRIM(CONVERT(varchar(15),@frag)) + '%';
   SELECT @execstr = 'DBCC INDEXDEFRAG (0, ' + RTRIM(@objectid) + ',
       ' + RTRIM(@indexid) + ')';
   EXEC (@execstr);

   FETCH NEXT
      FROM indexes
      INTO @tablename, @objectid, @indexid, @frag;
END;

-- Close and deallocate the cursor.
CLOSE indexes;
DEALLOCATE indexes;

-- Delete the temporary table.
DROP TABLE #fraglist;
GO





 Page Scanned-扫描页数：如果你知道行的近似尺寸和表或索引里的行数，那么你可以估计出索引里的页数。看看扫描页数，如果明显比你估计的页数要高，说明存在内部碎片。 

Extents Scanned-扫描扩展盘区数：用扫描页数除以8,四舍五入到下一个最高值。该值应该和DBCC SHOWCONTIG返回的扫描扩展盘区数一致。如果DBCC SHOWCONTIG返回的数高，说明存在外部碎片。碎片的严重程度依赖于刚才显示的值比估计值高多少。 

Extent Switches-扩展盘区开关数：该数应该等于扫描扩展盘区数减1。高了则说明有外部碎片。 

Avg. Pages per Extent-每个扩展盘区上的平均页数：该数是扫描页数除以扫描扩展盘区数，一般是8。小于8说明有外部碎片。 

Scan Density [Best Count:Actual Count]-扫描密度［最佳值:实际值］：DBCC SHOWCONTIG返回最有用的一个百分比。这是扩展盘区的最佳值和实际值的比率。该百分比应该尽可能靠近100％。低了则说明有外部碎片。

Logical Scan Fragmentation-逻辑扫描碎片：无序页的百分比。该百分比应该在0％到10％之间，高了则说明有外部碎片。 

Extent Scan Fragmentation-扩展盘区扫描碎片：无序扩展盘区在扫描索引叶级页中所占的百分比。该百分比应该是0％，高了则说明有外部碎片。 

Avg. Bytes Free per Page-每页上的平均可用字节数：所扫描的页上的平均可用字节数。越高说明有内部碎片，不过在你用这个数字决定是否有内部碎片之前，应该考虑fill factor（填充因子）。 

Avg. Page Density (full)-平均页密度（完整）：每页上的平均可用字节数的百分比的相反数。低的百分比说明有内部碎片