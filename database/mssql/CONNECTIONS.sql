SELECT * FROM
[Master].[dbo].[SYSPROCESSES] WHERE [DBID] IN ( SELECT 
   [DBID]
FROM 
   [Master].[dbo].[SYSDATABASES]
WHERE 
   NAME='edoc2v4'
)

SELECT @@MAX_CONNECTIONS


/*查询连接数*/
select loginame,count(1) as Nums
from sys.sysprocesses
group by loginame
order by 2 desc
 
--select spid,ecid,status,loginame,hostname,cmd,request_id 
--from sys.sysprocesses where loginame='' and hostname=''

--连接超时
select * from master.dbo.sysconfigures where comment like'%timeout%'
select value from master.dbo.sysconfigures where [config]=103


--、设置最大连接数
----下面的T-SQL 语句可以配置SQL Server 允许的并发用户连接的最大数目。
--exec sp_configure 'show advanced options', 1
--exec sp_configure 'user connections', 100
 

