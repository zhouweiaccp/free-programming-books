--查询当前数据库的配置信息
Select configuration_id ConfigurationId,
name Name,
description Description,
Cast(value as int) value,
Cast(minimum as int) Minimum,
Cast(maximum as int) Maximum,
Cast(value_in_use as int) ValueInUse,
is_dynamic IsDynamic,
is_advanced IsAdvanced
From sys.configurations
Order By is_advanced, name
go
--检查SQL SERVER 当前已创建的线程数
select count(*) from sys.dm_os_workers
go
--查询当前连接到数据库的用户信息
Select s.login_name LoginName,
s.host_name HostName,
s.transaction_isolation_level TransactionIsolationLevel,
Max(c.connect_time) LastConnectTime,
Count(*) ConnectionCount,
Sum(Cast(c.num_reads as BigInt)) TotalReads,
Sum(Cast(c.num_writes as BigInt)) TotalWrites
From sys.dm_exec_connections c
Join sys.dm_exec_sessions s
On c.most_recent_session_id = s.session_id
Group By s.login_name, s.host_name, s.transaction_isolation_level
go

--查询CPU和内存利用率
Select DateAdd(s, (timestamp - (osi.cpu_ticks / Convert(Float, (osi.cpu_ticks / osi.ms_ticks)))) / 1000, GETDATE()) AS EventTime,
Record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'int') as SystemIdle,
Record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 'int') as ProcessUtilization,
Record.value('(./Record/SchedulerMonitorEvent/SystemHealth/MemoryUtilization)[1]', 'int') as MemoryUtilization
From (Select timestamp,
convert(xml, record) As Record
From sys.dm_os_ring_buffers
Where ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR'
And record Like '%<SystemHealth>%') x
Cross Join sys.dm_os_sys_info osi
Order By timestamp

go
--查看每个数据库缓存大小
SELECT  COUNT(*) * 8 / 1024 AS 'Cached Size (MB)' ,
        CASE database_id
          WHEN 32767 THEN 'ResourceDb'
          ELSE DB_NAME(database_id)
        END AS 'Database'
FROM    sys.dm_os_buffer_descriptors
GROUP BY DB_NAME(database_id) ,
        database_id
ORDER BY 'Cached Size (MB)' DESC
go




--SQL SERVER  统计IO活动信息
SET STATISTICS IO ON
select top 10 * from dms_file
SET STATISTICS IO OFF

--SQL SERVER 清除缓存SQL语句
CHECKPOINT;
GO
DBCC  FREEPROCCACHE      ---清空执行计划缓存
DBCC DROPCLEANBUFFERS;   --清空数据缓存
GO

--查看当前进程的信息
DBCC INPUTBUFFER(51)


-- 查询缺失索引
SELECT
    DatabaseName = DB_NAME(database_id)
    ,[Number Indexes Missing] = count(*)
FROM sys.dm_db_missing_index_details
GROUP BY DB_NAME(database_id)
ORDER BY 2 DESC;
GO

--各种CPU和SQLSERVER版本组合自动配置的最大工作线程数
--CPU数                 32位计算机                        64位计算机
--<=4                     256                                   512
--  8                        288                                   576
-- 16                       352                                   704
-- 32                       480                                   960

SELECT
scheduler_address,
scheduler_id,
cpu_id,
status,
current_tasks_count,
current_workers_count,active_workers_count
FROM sys.dm_os_schedulers
go

--查看CPU数和user scheduler数目
 SELECT cpu_count,scheduler_count FROM sys.dm_os_sys_info
 --查看最大工作线程数
 SELECT max_workers_count FROM sys.dm_os_sys_infos



-- Recommendations and best practices
-- Let us now briefly look at the techniques to size the memory.

-- 1 GB of memory reserved for Operating System
-- 1 GB each for every 4 GB of RAM after the initial 4 GB, up to 16 GB of RAM
-- 1 GB each for every 8 GB in more than 16 GB of RAM
-- For example, if you have a 32 GB RAM Database Server, then memory to be given to Operating System would be

-- 1 GB, the minimum allocation
-- + 3 GB, since 16 GB – 4 GB = 12 GB; 12 GB divided by 4 GB (each 4 GB gets 1 GB) is 3GB.
-- + 2 GB, as 32 GB – 16 GB = 16 GB; 16 divided by 8 (each 8 GB after 16 GB gets 1 GB) is 2 GB
-- GB	MB	Recommended Setting	Command
-- 16	16384	12288	EXEC sys.sp_configure ‘max server memory (MB)’, ‘12288’; RECONFIGURE;
-- 32	32768	29491	EXEC sys.sp_configure ‘max server memory (MB)’, ‘29491’; RECONFIGURE;
-- 64	65536	58982	EXEC sys.sp_configure ‘max server memory (MB)’, ‘58982’; RECONFIGURE;
-- 128	131072	117964	EXEC sys.sp_configure ‘max server memory (MB)’, ‘117964’; RECONFIGURE;
-- 256	262144	235929	EXEC sys.sp_configure ‘max server memory (MB)’, ‘235929’; RECONFIGURE;
-- 512	524288	471859	EXEC sys.sp_configure ‘max server memory (MB)’, ‘471859’; RECONFIGURE;
-- 1024	1048576	943718	EXEC sys.sp_configure ‘max server memory (MB)’, ‘943718’; RECONFIGURE;
-- 2048	2097152	1887436	EXEC sys.sp_configure ‘max server memory (MB)’, ‘1887436’; RECONFIGURE;
-- 4096	4194304	3774873	EXEC sys.sp_configure’max server memory (MB)’, ‘3774873’; RECONFIGURE;

-- 系统内分配  https://codingsight.com/understanding-the-importance-of-memory-setting-in-sql-server/
SELECT 
	physical_memory_in_use_kb/1024 Physical_memory_in_use_MB, 
    large_page_allocations_kb/1024 Large_page_allocations_MB, 
    locked_page_allocations_kb/1024 Locked_page_allocations_MB,
    virtual_address_space_reserved_kb/1024 VAS_reserved_MB, 
    virtual_address_space_committed_kb/1024 VAS_committed_MB, 
    virtual_address_space_available_kb/1024 VAS_available_MB,
    page_fault_count Page_fault_count,
    memory_utilization_percentage Memory_utilization_percentage, 
    process_physical_memory_low Process_physical_memory_low, 
    process_virtual_memory_low Process_virtual_memory_low
FROM sys.dm_os_process_memory;

-- TotalVisibleMemorySize: This field shows the total physical memory that is accessible to the operating system. Inaccessible chunks of memory may cause a smaller-than-installed number to be displayed here.
-- FreePhysicalMemory: This tells us what amount of physical memory is free.
-- TotalVirtualMemorySize: This is the total virtual memory available for the OS to use. This comprises the physical memory installed on the computer, along with the size of the pagefile.
-- FreeVirtualMemory: Similar to FreePhysicalMemory, but includes the free space in the paging memory as well.



-- Set "max server memory" in SQL Server using T-SQL https://www.mssqltips.com/sqlservertip/4182/setting-a-fixed-amount-of-memory-for-sql-server/
-- 最大内存We can set "max server memory" also by using a T-SQL script:

DECLARE @maxMem INT = 2147483647 --Max. memory for SQL Server instance in MB
EXEC sp_configure 'show advanced options', 1
RECONFIGURE

EXEC sp_configure 'max server memory', @maxMem
RECONFIGURE
GO


-- List the queries running on SQL Server This will show you the longest running SPIDs on a SQL 2000 or SQL 2005 server: 
-- https://stackoverflow.com/questions/941763/list-the-queries-running-on-sql-server
select
    P.spid
,   right(convert(varchar, 
            dateadd(ms, datediff(ms, P.last_batch, getdate()), '1900-01-01'), 
            121), 12) as 'batch_duration'
,   P.program_name
,   P.hostname
,   P.loginame
from master.dbo.sysprocesses P
where P.spid > 50
and      P.status not in ('background', 'sleeping')
and      P.cmd not in ('AWAITING COMMAND'
                    ,'MIRROR HANDLER'
                    ,'LAZY WRITER'
                    ,'CHECKPOINT SLEEP'
                    ,'RA MANAGER')
order by batch_duration desc
go
-- If you need to see the SQL running for a given spid from the results, use something like this:
declare
    @spid int
,   @stmt_start int
,   @stmt_end int
,   @sql_handle binary(20)

set @spid = XXX -- Fill this in

select  top 1
    @sql_handle = sql_handle
,   @stmt_start = case stmt_start when 0 then 0 else stmt_start / 2 end
,   @stmt_end = case stmt_end when -1 then -1 else stmt_end / 2 end
from    sys.sysprocesses
where   spid = @spid
order by ecid

SELECT
    SUBSTRING(  text,
            COALESCE(NULLIF(@stmt_start, 0), 1),
            CASE @stmt_end
                WHEN -1
                    THEN DATALENGTH(text)
                ELSE
                    (@stmt_end - @stmt_start)
                END
        )
FROM ::fn_get_sql(@sql_handle)


-- I would suggest querying the sys views. something similar to

SELECT * 
FROM 
   sys.dm_exec_sessions s
   LEFT  JOIN sys.dm_exec_connections c
        ON  s.session_id = c.session_id
   LEFT JOIN sys.dm_db_task_space_usage tsu
        ON  tsu.session_id = s.session_id
   LEFT JOIN sys.dm_os_tasks t
        ON  t.session_id = tsu.session_id
        AND t.request_id = tsu.request_id
   LEFT JOIN sys.dm_exec_requests r
        ON  r.session_id = tsu.session_id
        AND r.request_id = tsu.request_id
   OUTER APPLY sys.dm_exec_sql_text(r.sql_handle) TSQL


-- 连接信息 https://stackoverflow.com/questions/1248423/how-do-i-see-active-sql-server-connections
SELECT conn.session_id, host_name, program_name,
    nt_domain, login_name, connect_time, last_request_end_time 
FROM sys.dm_exec_sessions AS sess
JOIN sys.dm_exec_connections AS conn
   ON sess.session_id = conn.session_id;

--查看当前数据是否启用了快照隔离
DBCC USEROPTIONS;

--查看摸个数据库数据表中的数据页类型
--In_Row_Data: 分别为存储行内数据的
	--LOB_Data: 存储Lob对象,Lob对象用于存储存在数据库的二进制文件
	          --当这个类型的列出现时,原有的列会存储一个24字节的指针，而将具体的二进制数据存在LOB页中
	--Row_Overflow_data:存储溢出数据的,使用Varchar,nvarchar等数据类型时，当行的大小不超过8060字节时，全部存在行内In-row data
					--当varchar中存储的数据过多使得整行超过8060字节时，会将额外的部分存于Row-overflow data页中，
					--如果update这列使得行大小减少到小于8060字节，则这行又会全部回到in-row data页
					--text,ntext和image类型来说，每一列只要不为null,即使占用很小的数据，也需要额外分配一个LOB页
DBCC IND ( edoc2v4, [dbo.dms_file], -1)




-- https://www.cnblogs.com/lyhabc/archive/2013/06/12/3133273.html SQLSERVER排查CPU占用高的情况
-- https://www.cnblogs.com/marvin/p/HowCanIHandleBigDataBySQLServer.html 我是如何在SQLServer中处理每天四亿三千万记录的
-- https://blog.csdn.net/gbtyy/article/details/42101271   有哪些SQL语句会导致CPU过高？
-- 上网查看了下文章，得出以下结论：

-- 1.编译和重编译

-- 编译是 Sql Server 为指令生成执行计划的过程。Sql Server 要分析指令要做的事情，分析它所要访问的表格结构，也就是生成执行计划的过程。这个过程主要是在做各种计算，所以CPU 使用比较集中的地方。

-- 执行计划生成后会被缓存在 内存中，以便重用。但是不是所有的都可以 被重用。在很多时候，由于数据量发生了变化，或者数据结构发生了变化，同样一句话执行，就要重编译。

-- 2.排序（sort） 和 聚合计算（aggregation）

-- 在查询的时候，经常会做 order by、distinct 这样的操作，也会做 avg、sum、max、min 这样的聚合计算，在数据已经被加载到内存后，就要使用CPU把这些计算做完。所以这些操作的语句CPU 使用量会多一些。

-- 3.表格连接（Join）操作

-- 当语句需要两张表做连接的时候，SQLServer 常常会选择 Nested Loop 或 Hash 算法。算法的完成要运行 CPU，所以 join 有时候也会带来 CPU 使用比较集中的地方。

-- 4.Count(*) 语句执行的过于频繁

-- 特别是对大表 Count() ，因为 Count() 后面如果没有条件，或者条件用不上索引，都会引起 全表扫描的，也会引起 CPU 的大量运算

-- 大致的原因，我们都知道了，但是具体到我们上述的两个SQL，好像都有上述提到的这些问题，那么到底哪个才是最大的元凶，我们能够怎么优化？

-- 查看SQL的查询计划
-- SQLServer的查询计划很清楚的告诉了我们到底在哪一步消耗了最大的资源。我们先来看看获取top30的记录：



-- 排序竟然占了94%的资源。原来是它！同事马上想到，用orderno排序会不会快点。先把上述语句在SQLServer中执行一遍，清掉缓存之后，大概是2~3秒，然后排序字段改为orderno，1秒都不到，果然有用。但是orderno的顺序跟alarmTime的顺序是不完全一致的，orderno的排序无法替代alarmTime排序，那么怎么办？我想，因为选择的是top，那么因为orderno是聚集索引，那么选择前30条记录，可以立即返回，根本无需遍历整个结果，那么如果alarmTime是个索引字段，是否可以加快排序？

-- 选择top记录时，尽量为order子句的字段建立索引
-- 先建立索引：

-- IF NOT EXISTS(SELECT * FROM sysindexes WHERE id=OBJECT_ID('eventlog') AND name='IX_eventlog_alarmTime')
-- 	CREATE NONCLUSTERED INDEX IX_eventlog_alarmTime ON dbo.eventlog(AlarmTime)
-- 在查看执行计划：



-- 看到没有，刚才查询耗时的Sort已经消失不见了，那么怎么验证它能够有效的降低我们的CPU呢，难道要到现场部署，当然不是。

-- 查看SQL语句CPU高的语句
-- SELECT TOP 10 TEXT AS 'SQL Statement'
--     ,last_execution_time AS 'Last Execution Time'
--     ,(total_logical_reads + total_physical_reads + total_logical_writes) / execution_count AS [Average IO]
--     ,(total_worker_time / execution_count) / 1000000.0 AS [Average CPU Time (sec)]
--     ,(total_elapsed_time / execution_count) / 1000000.0 AS [Average Elapsed Time (sec)]
--     ,execution_count AS "Execution Count",qs.total_physical_reads,qs.total_logical_writes
--     ,qp.query_plan AS "Query Plan"
-- FROM sys.dm_exec_query_stats qs
-- CROSS APPLY sys.dm_exec_sql_text(qs.plan_handle) st
-- CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
-- ORDER BY total_elapsed_time / execution_count DESC
-- 我们把建索引前后CPU做个对比：



-- 已经明显减低了。

-- 通过建立相关索引来减少表扫描
-- 我们再来看看count(*)这句怎么优化，因为上面的这句跟count这句差别就在于order by的排序。老规矩，用查询计划看看。



-- 用语句select count(0) from eventlog一看，该表已经有20多w的记录，每次查询30条数据，竟然要遍历这个20多w的表两次，能不耗CPU吗。我们看看是否能够利用相关的条件来减少表扫描。很明显，我们可以为MgrObjId建立索引：

-- CREATE NONCLUSTERED INDEX IX_eventlog_moid ON dbo.eventlog(MgrObjId)

-- 但是无论我怎么试，都是没有利用到索引，难道IN子句和NOT IN子句是没法利用索引一定会引起表扫描。于是上网查资料，找到桦仔的文章，这里面有解答：

-- SQLSERVER对筛选条件（search argument/SARG）的写法有一定的建议

-- 对于不使用SARG运算符的表达式，索引是没有用的，SQLSERVER对它们很难使用比较优化的做法。非SARG运算符包括

-- NOT、<>、NOT EXISTS、NOT IN、NOT LIKE和内部函数，例如：Convert、Upper等

-- 但是这恰恰说明了IN是可以建立索引的啊。百思不得其解，经过一番的咨询之后，得到了解答：

-- 不一定是利用索引就是好的,sqlserver根据你的查询的字段的重复值的占比，决定是表扫描还是索引扫描

-- 有道理，但是我查看了下，重复值并不高，怎么会有问题呢。

-- 关键是，你select的字段，这个地方使用索引那么性能更差，你select字段 id,addrid,agentbm,mgrobjtypeid,name都不在索引里。

-- 真是一语惊醒梦中人，缺的是包含索引！！！关于包含索引的重要性我在这篇文章《我是如何在SQLServer中处理每天四亿三千万记录的》已经提到过了，没想到在这里又重新栽了个跟头。实践，真的是太重要了！

-- 通过建立包含索引来让SQL语句走索引
-- 好吧，立马建立相关索引：

-- IF NOT EXISTS(SELECT * FROM sysindexes WHERE id=OBJECT_ID('eventlog') AND name='IX_eventlog_moid')
-- 	CREATE NONCLUSTERED INDEX IX_eventlog_moid ON dbo.eventlog(MgrObjId) INCLUDE(EventBm,AgentBM)
-- 我们再来看看查询计划：



-- 看到没有，已经没有eventlog表的表扫描了。我们再来比较前后的CPU：



-- 很明显，这个count的优化，对查询top的语句依然的生效的。目前为止，这两个查询用上去之后，再也没有CPU过高的现象了。

-- 其他优化手段
-- 通过服务端的推送，有事件告警或者解除过来才查询数据库。
-- 优化上述查询语句，比如count(*)可以用count(0)替代——参考《SQL开发技巧(二)》
-- 优化语句，先查询出所有的MgrObjId，然后在做连接
-- 为管理对象、地点表等增加索引
-- 添加了索引之后，事件表的插入就会慢，能够再怎么优化呢？可以分区建立索引，每天不忙的时候，把新的记录移入到建好索引的分区
-- 当然，这些优化的手段是后续的事情了，我要做的事情基本完了。

-- 总结
-- 服务器CPU过高，首先查看系统进程，确定引发CPU过高的进程
-- 通过SQLServer Profiler能够轻易监控到哪些SQL语句执行时间过长，消耗最多的CPU
-- 通过SQL语句是可以查看每条SQL语句消耗的CPU是多少
-- 导致CPU高的都是进行大量计算的语句：包括内存排序、表扫描、编译计划等。
-- 如果使用Top刷选前面几条语句，则尽量为Order By子句建立索引，这样可以减少对所有的刷选结果进行排序
-- 使用Count查询记录数时，尽量通过为where字句的相关字段建立索引以减少表扫描。如果多个表进行join操作，则把相关的表连接字段建立在包含索引中
-- 通过服务端通知的方式，减少SQL语句的查询
-- 通过表分区，尽量降低因为添加索引而导致表插入较慢的影响