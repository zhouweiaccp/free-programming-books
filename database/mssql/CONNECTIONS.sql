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


--脚本能够直观的看到数据库中SQL 的运行状态，快速找到执行缓慢的语句。这是我使用最频繁的脚本之一.https://blog.csdn.net/z10843087/article/details/76040459
SELECT
    es.session_id,
    database_name=DB_NAME(er.database_id),
    er.cpu_time,
    er.reads,
    er.writes,
    er.logical_reads,
    login_name,
    er.status,
    blocking_session_id,
    wait_type,
    wait_resource,
    wait_time,
    individual_query=SUBSTRING(qt.text,(er.statement_start_offset/2)+1,((CASE  WHEN  er.statement_end_offset=-1 THEN  LEN(CONVERT(NVARCHAR(MAX),qt.text))* 2 ELSE   er.statement_end_offset  END-er.statement_start_offset)/2)+1),
    parent_query=qt.text,
    program_name,
    host_name,
    nt_domain,
    start_time,
    DATEDIFF(MS,er.start_time,GETDATE())as duration,
    (SELECT  query_plan  FROM  sys.dm_exec_query_plan (er.plan_handle))AS  query_plan
FROM
    sys.dm_exec_requests er
    INNER  JOIN  sys.dm_exec_sessions  es  ON er.session_id=es.session_id
    CROSS  APPLY  sys.dm_exec_sql_text (er.sql_handle)AS  qt
WHERE
    es.session_id> 50         
    AND  es.session_Id  NOT  IN(@@SPID)
ORDER BY 1,2

-- 重要信息
-- logical_reads:逻辑读，衡量语句的执行开销。如果大于10w，说明此语句开销很大。可以检查下索引是否合理

-- status：进程的状态。running 表示正在运行，sleeping 表示处于睡眠中，未运行任何语句，suspend 表示等待，runnable 等待cpu 调度

-- blocking_session_id: 如果不为0,例如 60 。表示52号进程正在被60阻塞。50 进程必须等待60执行完成，才能执行下面的语句

-- host_name ：发出请求的服务器名

-- program_name:发出请求的应用程序名

-- duration: 请求的执行时间

--10. Get the top 10 queries consuming High CPU using below query:https://blogs.msdn.microsoft.com/docast/2017/07/30/sql-high-cpu-troubleshooting-checklist/

SELECT s.session_id,

r.status,

r.blocking_session_id 'Blk by',

r.wait_type,

wait_resource,

r.wait_time / (1000 * 60) 'Wait M',

r.cpu_time,

r.logical_reads,

r.reads,

r.writes,

r.total_elapsed_time / (1000 * 60) 'Elaps M',

Substring(st.TEXT,(r.statement_start_offset / 2) + 1,

((CASE r.statement_end_offset

WHEN -1

THEN Datalength(st.TEXT)

ELSE r.statement_end_offset

END - r.statement_start_offset) / 2) + 1) AS statement_text,

Coalesce(Quotename(Db_name(st.dbid)) + N'.' + Quotename(Object_schema_name(st.objectid, st.dbid)) + N'.' +
Quotename(Object_name(st.objectid, st.dbid)), '') AS command_text,
r.command,

s.login_name,

s.host_name,

s.program_name,

s.last_request_end_time,

s.login_time,

r.open_transaction_count

FROM sys.dm_exec_sessions AS s

JOIN sys.dm_exec_requests AS r

ON r.session_id = s.session_id

CROSS APPLY sys.Dm_exec_sql_text(r.sql_handle) AS st

WHERE r.session_id != @@SPID

ORDER BY r.cpu_time desc



-- 这些内存一般都是Sql Server运行时候用作缓存的:
-- 1. 数据缓存：执行个查询语句，Sql Server会将相关的数据页（Sql Server操作的数据都是以页为单位的）加载到内存中来， 下一次如果再次请求此页的数据的时候，就无需读取磁盘了，大大提高了速度。

 
-- 2.执行命令缓存：在执行存储过程，自定函数时，Sql Server需要先二进制编译再运行，编译后的结果也会缓存起来， 再次调用时就无需再次编译。
---可以调用以下几个DBCC管理命令来清理这些缓存
DBCC FREEPROCCACHE --清除存储过程相关的缓存
DBCC FREESESSIONCACHE --会话缓存
DBCC FREESYSTEMCACHE('All') --系统缓存
DBCC DROPCLEANBUFFERS --所有缓存
