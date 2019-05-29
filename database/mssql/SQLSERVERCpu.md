https://www.cnblogs.com/lyhabc/archive/2013/06/12/3133273.html


 USE master
 GO
 --如果要指定数据库就把注释去掉
 SELECT * FROM sys.[sysprocesses] WHERE [spid]>50 --AND DB_NAME([dbid])='gposdb'
 --看一下当前的数据库用户连接有多少
 SELECT COUNT(*) FROM [sys].[dm_exec_sessions] WHERE [session_id]>50


--使用下面语句看一下各项指标是否正常，是否有阻塞，这个语句选取了前10个最耗CPU时间的会话
 SELECT TOP 10
[session_id],
[request_id],
[start_time] AS '开始时间',
[status] AS '状态',
[command] AS '命令',
dest.[text] AS 'sql语句', 
DB_NAME([database_id]) AS '数据库名',
[blocking_session_id] AS '正在阻塞其他会话的会话ID',
[wait_type] AS '等待资源类型',
[wait_time] AS '等待时间',
[wait_resource] AS '等待的资源',
[reads] AS '物理读次数',
[writes] AS '写次数',
[logical_reads] AS '逻辑读次数',
[row_count] AS '返回结果行数'
FROM sys.[dm_exec_requests] AS der 
CROSS APPLY 
sys.[dm_exec_sql_text](der.[sql_handle]) AS dest 
WHERE [session_id]>50 AND DB_NAME(der.[database_id])='gposdb'  
ORDER BY [cpu_time] DESC

--想看具体的SQL语句可以执行下面的SQL语句，记得在SSMS里选择以文本格式显示结果

SELECT TOP 10 
dest.[text] AS 'sql语句'
FROM sys.[dm_exec_requests] AS der 
CROSS APPLY 
sys.[dm_exec_sql_text](der.[sql_handle]) AS dest 
WHERE [session_id]>50  
ORDER BY [cpu_time] DESC

 --查看CPU数和user scheduler数目
 SELECT cpu_count,scheduler_count FROM sys.dm_os_sys_info
 --查看最大工作线程数
 SELECT max_workers_count FROM sys.dm_os_sys_info


--各种CPU和SQLSERVER版本组合自动配置的最大工作线程数
 SELECT
scheduler_address,
scheduler_id,
cpu_id,
status,
current_tasks_count,
current_workers_count,active_workers_count
FROM sys.dm_os_schedulers

--如果SQLSERVER存在要等待的资源，那么执行下面语句就会显示出会话中有多少个worker在 等待结合[sys].[dm_os_wait_stats]视图，如果当前SQLSERVER里面没有任何等待资源，那么下面的SQL语句不会显示任何结果
SELECT TOP 10
 [session_id],
 [request_id],
 [start_time] AS '开始时间',
 [status] AS '状态',
 [command] AS '命令',
 dest.[text] AS 'sql语句', 
 DB_NAME([database_id]) AS '数据库名',
 [blocking_session_id] AS '正在阻塞其他会话的会话ID',
 der.[wait_type] AS '等待资源类型',
 [wait_time] AS '等待时间',
 [wait_resource] AS '等待的资源',
 [dows].[waiting_tasks_count] AS '当前正在进行等待的任务数',
 [reads] AS '物理读次数',
 [writes] AS '写次数',
 [logical_reads] AS '逻辑读次数',
 [row_count] AS '返回结果行数'
 FROM sys.[dm_exec_requests] AS der 
 INNER JOIN [sys].[dm_os_wait_stats] AS dows 
 ON der.[wait_type]=[dows].[wait_type]
 CROSS APPLY 
 sys.[dm_exec_sql_text](der.[sql_handle]) AS dest 
 WHERE [session_id]>50  
 ORDER BY [cpu_time] DESC


 ---查询CPU占用高的语句
 SELECT TOP 10
   total_worker_time/execution_count AS avg_cpu_cost, plan_handle,
   execution_count,
   (SELECT SUBSTRING(text, statement_start_offset/2 + 1,
      (CASE WHEN statement_end_offset = -1
         THEN LEN(CONVERT(nvarchar(max), text)) * 2
         ELSE statement_end_offset
      END - statement_start_offset)/2)
   FROM sys.dm_exec_sql_text(sql_handle)) AS query_text
FROM sys.dm_exec_query_stats
ORDER BY [avg_cpu_cost] D

---查询缺失索引

SELECT 
    DatabaseName = DB_NAME(database_id)
    ,[Number Indexes Missing] = count(*) 
FROM sys.dm_db_missing_index_details
GROUP BY DB_NAME(database_id)
ORDER BY 2 DESC;



SELECT  TOP 10 
        [Total Cost]  = ROUND(avg_total_user_cost * avg_user_impact * (user_seeks + user_scans),0) 
        , avg_user_impact
        , TableName = statement
        , [EqualityUsage] = equality_columns 
        , [InequalityUsage] = inequality_columns
        , [Include Cloumns] = included_columns
FROM        sys.dm_db_missing_index_groups g 
INNER JOIN    sys.dm_db_missing_index_group_stats s 
       ON s.group_handle = g.index_group_handle 
INNER JOIN    sys.dm_db_missing_index_details d 
       ON d.index_handle = g.index_handle
ORDER BY [Total Cost] DESC;

定位问题后，新建非聚集索引
CREATE NONCLUSTERED INDEX IX_t_AccessControl_F4 ON dbo.t_AccessControl
(
    FObjectType
)include([FUserID], [FAccessType], [FAccessMask]) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

drop index IX_t_AccessControl_F4 on t_AccessControl