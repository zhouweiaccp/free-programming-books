SELECT * FROM
[Master].[dbo].[SYSPROCESSES] WHERE [DBID] IN ( SELECT 
   [DBID]
FROM 
   [Master].[dbo].[SYSDATABASES]
WHERE 
   NAME='edoc2v4'
)

SELECT @@MAX_CONNECTIONS


/*��ѯ������*/
select loginame,count(1) as Nums
from sys.sysprocesses
group by loginame
order by 2 desc
 
--select spid,ecid,status,loginame,hostname,cmd,request_id 
--from sys.sysprocesses where loginame='' and hostname=''

--���ӳ�ʱ
select * from master.dbo.sysconfigures where comment like'%timeout%'
select value from master.dbo.sysconfigures where [config]=103


--���������������
----�����T-SQL ����������SQL Server ����Ĳ����û����ӵ������Ŀ��
--exec sp_configure 'show advanced options', 1
--exec sp_configure 'user connections', 100
 

