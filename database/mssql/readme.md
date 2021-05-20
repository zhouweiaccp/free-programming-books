
https://github.com/SqlAdmin/AwesomeSQLServer 性能计数  cpu mem disk
https://github.com/SqlAdmin/  比较 table row index object


## MSSQL]帐户当前被锁定,所以用户 sa 登录失败。系统管理员无法将该帐户解锁 解决方法
ALTER LOGIN sa ENABLE ;
GO
ALTER LOGIN sa WITH PASSWORD = 'password' unlock, check_policy = off,
check_expiration = off ;
GO

##  MSSQLSERVER 时间差计算
SELECT datediff(yy,'2010-06-1 10:10',GETDATE()) --计算多少年
SELECT datediff(q,'2011-01-1 10:10',GETDATE())  --计算多少季度 3个月一个季度
SELECT datediff(mm,'2011-06-1 10:10',GETDATE()) --计算多少月
SELECT datediff(dd,'2011-06-1 10:10',GETDATE()) --计算多少天
SELECT datediff(wk,'2011-06-1 10:10',GETDATE()) --计算多少周
SELECT datediff(hh,'2011-06-10 10:10','2011-06-10 11:10') --计算多少小时
SELECT datediff(n,'2011-06-10 10:10','2011-06-10 10:11') --计算多少分钟 经验证会有误差
SELECT datediff(ss,'2011-06-10 10:10:00','2011-06-10 10:10:10') --计算多少秒
SELECT datediff(ms,'2011-06-16 10:10:10','2011-06-16 10:10:11') --计算多少毫秒

## SQL语句增加列、修改列、删除列 

1.增加列：
1.alter table tableName add columnName varchar(30)  
2.ALTER TABLE dbo.doc_exa ADD column_b VARCHAR(20) NULL, column_c INT NULL ;

2.1. 修改列类型：
1.alter table tableName alter column columnName varchar(4000)  

2.2. 修改列的名称：
1.EXEC  sp_rename   'tableName.column1' , 'column2'  (把表名为tableName的column1列名修改为column2)
下面的示例将 TerritoryID 表中的 Sales.SalesTerritory 列重命名为 TerrID。 将以下示例复制并粘贴到查询窗口中，然后单击“执行” 
EXEC sp_rename 'Sales.SalesTerritory.TerritoryID', 'TerrID', 'COLUMN';  
GO  
3.删除列： 1.alter table tableName drop column columnName
4,指定表中某列默认数据
ALTER TABLE dbo.doc_exz ADD CONSTRAINT col_b_def DEFAULT 50 FOR column_b ;
## 主键插入IDENTITY
CREATE TABLE Orders(
OrderID    INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
PriceDate DateTime
)
SET IDENTITY_INSERT Orders ON
INSERT INTO Orders (OrderID ,PriceDate ) VALUES(1,GETDATE())
SET IDENTITY_INSERT Orders OFF
## 连接数
SELECT @@MAX_CONNECTIONS
select * from sysprocesses where dbid in (select dbid from sysdatabases where name='master1')
<!--  https://docs.microsoft.com/en-us/sql/relational-databases/system-compatibility-views/sys-sysprocesses-transact-sql?view=sql-server-ver15 -->
## Could not allocate a new page for database 'TEMPDB' because of insufficient disk space in filegroup 'DEFAULT
就是因为服务器由于磁盘空间不足或数据库文件限制了最大大小，导致SQL Server无法为数据库分配新的页面，请检查磁盘空间是否足够或给数据库文件设置自动增长




## 收缩的数据库
USE testdb
ALTER DATABASE testdb SET RECOVERY SIMPLE
ALTER DATABASE testdb SET RECOVERY FULL
DBCC SHRINKDATABASE(testdb,0)

## 最大空间
ALTER DATABASE [SQLDWDB] MODIFY ( MAXSIZE=245760 GB );


## SQLServer性能优化之 nolock，大幅提升数据库查询性能
NOLOCK的使用

　　NOLOCK可以忽略锁，直接从数据库读取数据。这意味着可以避开锁，从而提高性能和扩展性。但同时也意味着代码出错的可能性存在。你可能会读取到运行事务正在处理的无须验证的未递交数据。 这种风险可以量化。

ROWLOCK的使用

　　ROWLOCK告诉SQL Server只使用行级锁。ROWLOCK语法可以使用在SELECT,UPDATE和DELETE语句中，不过 我习惯仅仅在UPDATE和DELETE语句中使用。如果在UPDATE语句中有指定的主键，那么就总是会引发行级锁的。但是当SQL Server对几个这种UPDATE进行批处理时，某些数据正好在同一个页面(page)，这种情况在当前情况下 是很有可能发生的，这就象在一个目录中，创建文件需要较长的时间，而同时你又在更新这些文件。当页面锁引发后，事情就开始变得糟糕了。而如果在UPDATE或者DELETE时，没有指定主键，数据库当然认为很多数据会收到影响，那样 就会直接引发页面锁，事情同样变得糟糕。
https://www.cnblogs.com/yunfeifei/p/3848644.html

### 慢sql
- [用于对运行慢的查询进行分析的清单](https://docs.microsoft.com/zh-cn/previous-versions/sql/sql-server-2005/ms177500(v=sql.90))

### 2.查看查询对I/0的操作情况

set statistics io on
select * from dbo.Product
set statistics io off
扫描计数：索引或表扫描次数

逻辑读取：数据缓存中读取的页数

物理读取：从磁盘中读取的页数

预读：查询过程中，从磁盘放入缓存的页数

lob逻辑读取：从数据缓存中读取，image，text，ntext或大型数据的页数

lob物理读取：从磁盘中读取，image，text，ntext或大型数据的页数

lob预读：查询过程中，从磁盘放入缓存的image，text，ntext或大型数据的页数
https://www.cnblogs.com/knowledgesea/p/3686105.html



## SQL Server导入超大SQL文件的方法
cd C:\Program Files\Microsoft SQL Server\100\Tools\Binn （具体目录路径跟你安装的SQL位置有关）

键入：
sqlcmd -S localhost -U username -P 123456 -d dbname -i db.sql
参数说明：-S 服务器地址 -U 用户名 -P 密码 -d 数据库名称 -i 脚本文件路径

osql -S serverIP -U sa -P 123 -i C:\script.sql
## 帮助文档
- [sp_datatype_info](https://docs.microsoft.com/zh-cn/sql/relational-databases/system-stored-procedures/sp-datatype-info-transact-sql?view=sql-server-ver15#examples)  EXEC sp_datatype_info
- [sp_help]()EXEC sp_help;    exec sp_help @objname='Sys_PositionList'
- [优化指南](https://docs.microsoft.com/zh-cn/sql/big-data-cluster/performance-guidelines-tuned?view=sql-server-ver15) 
- []()
- []()
- []()
## 客户端下载
[](https://download.microsoft.com/download/f/e/b/feb0e6be-21ce-4f98-abee-d74065e32d0a/SSMS-Setup-CHS.exe)