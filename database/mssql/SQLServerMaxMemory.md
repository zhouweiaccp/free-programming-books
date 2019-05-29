https://blog.csdn.net/hankersyan/article/details/50281253
为保证系统有足够的内存，减少虚拟内存交换的影响，SQLServer的最大内存应有设置，经验表如下。如果系统还运行了其他服务，SQLServer的最大内存应相应减少。

原帖
http://www.sqlservercentral.com/blogs/glennberry/2009/10/29/suggested-max-memory-settings-for-sql-server-2005_2F00_2008/

Suggested Max Memory Settings for SQL Server 2005/2008
Posted on 29 October 2009
Comments
  Briefcase
  Print
It is pretty important to make sure you set the Max Server memory setting for SQL Server 2005/2008 to something besides the default setting (which allows SQL Server to use as much memory as it wants, subject to signals from the operating system that it is under memory pressure). This is especially important with larger, busier systems that may be under memory pressure. 

This setting controls how much memory can be used by the SQL Server Buffer Pool.  If you don’t set an upper limit for this value, other parts of SQL Server, and the operating system can be starved for memory, which can cause instability and performance problems. It is even more important to set this correctly if you have “Lock Pages in Memory” enabled for the SQL Server service account (which I always do for x64 systems with more than 4GB of memory).

These settings are for x64, on a dedicated database server, only running the DB engine, (which is the ideal situation).

Physical RAM                        MaxServerMem Setting 
2GB                                           1500 
4GB                                           3200 
6GB                                           4800 
8GB                                           6400 
12GB                                         10000 
16GB                                         13500 
24GB                                         21500 
32GB                                         29000 
48GB                                         44000 
64GB                                         60000
72GB                                         68000
96GB                                         92000
128GB                                       124000

If you are running other SQL Server components, such as SSIS or Full Text Search, you will want to allocate less memory for the SQL Server Buffer Pool. You also want to pay close attention to how much memory is still available in Task Manager. This is how much RAM should be available in Task Manager while you are under load (on Windows Server 2003):

Physical RAM            Target Avail RAM in Task Manager 
< 4GB                               512MB – 1GB 
4-32GB                              1GB – 2GB 
32-128GB                            2GB – 4GB 
> 128GB                              > 4GB

You can use T-SQL to set your MaxServerMemory setting. The sample below sets it to 3500, which is the equivalent of 3.5GB. This setting is dynamic in SQL Server 2005/2008, which means that you can change it and it goes into effect immediately, without restarting SQL Server.

-- Turn on advanced options
EXEC  sp_configure'Show Advanced Options',1;
GO
RECONFIGURE;
GO

-- Set max server memory = 3500MB for the server
EXEC  sp_configure'max server memory (MB)',3500;
GO
RECONFIGURE;
GO

-- See what the current values are
EXEC sp_configure;
You can also change this setting in the SSMS GUI, as you see below:

 image

Finally, I have learned that it is a good idea to temporarily adjust your MaxServerMemory setting downward by a few GB if you know you will be doing a large file copy on your database server (such as copying a large database backup file).