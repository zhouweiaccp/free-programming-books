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
 

--最近执行较慢的SQL
SELECT TOP 10 OBJECT_NAME(qt.objectid, qt.dbId)  AS procName,
       DB_NAME(qt.dbId)                   AS [db_name],
       qt.text                            AS SQL_Full,
       SUBSTRING(
           qt.text,
           (qs.statement_start_offset / 2) + 1,
           (
               (
                   CASE statement_end_offset
                        WHEN -1 THEN DATALENGTH(qt.text)
                        ELSE qs.statement_end_offset
                   END 
                   - qs.statement_start_offset
               ) / 2
           ) + 1
       )                                  AS SQL_Part --统计对应的部分语句
       ,
       qs.creation_time,
       qs.last_execution_time,
       qs.execution_count,
       qs.last_elapsed_time / 1000000     AS lastElapsedSeconds,
       qs.last_worker_time / 1000000      AS lastCpuSeconds,
       CAST(
           qs.total_elapsed_time / 1000000.0 / (
               CASE 
                    WHEN qs.execution_count = 0 THEN -1
                    ELSE qs.execution_count
               END
           ) AS DECIMAL(28, 2)
       )                                  AS avgDurationSeconds,
       CAST(qs.last_logical_reads AS BIGINT) * 1.0 / (1024 * 1024) * 8060 AS 
       lastLogicReadsMB,
       qs.last_logical_reads,
       qs.plan_handle
FROM   sys.dm_exec_query_stats qs
       CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) AS p
WHERE  qs.last_execution_time >= CONVERT(CHAR(10),GETDATE(),120)+' 08:00'	--今天8点之后的慢SQL
       AND qs.last_elapsed_time >= 3 * 1000 * 1000							--只取执行时间大于 3 秒的记录
       AND qt.[text] NOT LIKE '%Proc_DBA%'
ORDER BY  qs.last_worker_time DESC

--带执行计划
SELECT TOP 5 
  CAST(qs.total_elapsed_time / 1000000.0 AS DECIMAL(28, 2)) 
                                     AS [Total Duration (s)] 
  , CAST(qs.total_worker_time * 100.0 / qs.total_elapsed_time 
                               AS DECIMAL(28, 2)) AS [% CPU] 
  , CAST((qs.total_elapsed_time - qs.total_worker_time)* 100.0 / 
        qs.total_elapsed_time AS DECIMAL(28, 2)) AS [% Waiting] 
  ,qs.last_logical_reads
  ,qs.creation_time
  ,qs.last_execution_time
  , qs.execution_count 
  , CAST(qs.total_elapsed_time / 1000000.0 / qs.execution_count 
                AS DECIMAL(28, 2)) AS [Average Duration (s)] 
  , SUBSTRING (qt.text,(qs.statement_start_offset/2) + 1,      
    ((CASE WHEN qs.statement_end_offset = -1 
      THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2 
      ELSE qs.statement_end_offset 
      END - qs.statement_start_offset)/2) + 1) AS [Individual Query]
  , qt.text AS [Parent Query] 
  , DB_NAME(qt.dbid) AS DatabaseName 
  , qp.query_plan 
FROM sys.dm_exec_query_stats qs 
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as qt 
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp 
WHERE qs.total_elapsed_time > 0 
      and qs.last_execution_time>'2017/05/25  07:00:24'
	  and qs.execution_count > 50
ORDER BY qs.total_elapsed_time DESC



SELECT TOP 10
		st.text AS SQL_Full										--父级完整语句
		,SUBSTRING(st.text, (qs.statement_start_offset/2) + 1,
			((CASE statement_end_offset 
			WHEN -1 THEN DATALENGTH(st.text)
			ELSE qs.statement_end_offset END 
			- qs.statement_start_offset)/2) + 1) as SQL_Part	--统计对应的部分语句
		, CAST( ((qs.total_elapsed_time / 1000000.0)/qs.execution_count) AS DECIMAL(28,2) ) AS [平均消耗秒数]
		, CAST(qs.last_elapsed_time / 1000000.0 AS DECIMAL(28, 2)) AS [最后完成消耗秒数]
		, qs.last_execution_time AS [最后执行时间]
		, CAST(qs.min_elapsed_time / 1000000.0 AS DECIMAL(28, 2)) AS [最小消耗秒数]
		, CAST(qs.max_elapsed_time / 1000000.0 AS DECIMAL(28, 2)) AS [最大消耗秒数]
		, CAST(qs.total_elapsed_time / 1000000.0 AS DECIMAL(28, 2)) AS [总消耗秒数]
		, (qs.execution_count) AS [总执行次数]
		, creation_time AS [编译计划的时间]
		, CAST(qs.last_worker_time / 1000000.0 AS DECIMAL(28, 2)) AS [最后完成占用CPU秒数]
		, qp.query_plan
    from sys.dm_exec_query_stats qs
        CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
        CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
WHERE qs.last_execution_time>DATEADD(n,-30,GETDATE())
ORDER BY qs.last_worker_time DESC
--------------------- https://blog.csdn.net/yenange/article/details/77187569



-- 这些内存一般都是Sql Server运行时候用作缓存的:
-- 1. 数据缓存：执行个查询语句，Sql Server会将相关的数据页（Sql Server操作的数据都是以页为单位的）加载到内存中来， 下一次如果再次请求此页的数据的时候，就无需读取磁盘了，大大提高了速度。

 
-- 2.执行命令缓存：在执行存储过程，自定函数时，Sql Server需要先二进制编译再运行，编译后的结果也会缓存起来， 再次调用时就无需再次编译。
---可以调用以下几个DBCC管理命令来清理这些缓存
DBCC FREEPROCCACHE --清除存储过程相关的缓存
DBCC FREESESSIONCACHE --会话缓存
DBCC FREESYSTEMCACHE('All') --系统缓存
DBCC DROPCLEANBUFFERS --所有缓存
