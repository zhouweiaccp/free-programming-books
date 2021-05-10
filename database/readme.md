(Mycat数据库分库分表中间件)[http://www.mycat.io/]
Mycat关键特性
关键特性
支持SQL92标准
支持MySQL、Oracle、DB2、SQL Server、PostgreSQL等DB的常见SQL语法
遵守Mysql原生协议，跨语言，跨平台，跨数据库的通用中间件代理。
基于心跳的自动故障切换，支持读写分离，支持MySQL主从，以及galera cluster集群。
支持Galera for MySQL集群，Percona Cluster或者MariaDB cluster
基于Nio实现，有效管理线程，解决高并发问题。
支持数据的多片自动路由与聚合，支持sum,count,max等常用的聚合函数,支持跨库分页。
支持单库内部任意join，支持跨库2表join，甚至基于caltlet的多表join。
支持通过全局表，ER关系的分片策略，实现了高效的多表join查询。
支持多租户方案。
支持分布式事务（弱xa）。
支持XA分布式事务（1.6.5）。
支持全局序列号，解决分布式下的主键生成问题。
分片规则丰富，插件化开发，易于扩展。
强大的web，命令行监控。
支持前端作为MySQL通用代理，后端JDBC方式支持Oracle、DB2、SQL Server 、 mongodb 、巨杉。
支持密码加密
支持服务降级
支持IP白名单
支持SQL黑名单、sql注入攻击拦截
支持prepare预编译指令（1.6）
支持非堆内存(Direct Memory)聚合计算（1.6）
支持PostgreSQL的native协议（1.6）
支持mysql和oracle存储过程，out参数、多结果集返回（1.6）
支持zookeeper协调主从切换、zk序列、配置zk化（1.6）
支持库内分表（1.6）
集群基于ZooKeeper管理，在线升级，扩容，智能优化，大数据处理（2.0开发版）。
什么是MYCAT
一个彻底开源的，面向企业应用开发的大数据库集群
支持事务、ACID、可以替代MySQL的加强版数据库
一个可以视为MySQL集群的企业级数据库，用来替代昂贵的Oracle集群
一个融合内存缓存技术、NoSQL技术、HDFS大数据的新型SQL Server
结合传统数据库和新型分布式数据仓库的新一代企业级数据库产品
一个新颖的数据库中间件产品
MYCAT监控
支持对Mycat、Mysql性能监控
支持对Mycat的JVM内存提供监控服务
支持对线程的监控
支持对操作系统的CPU、内存、磁盘、网络的监控


## mysql连接字符
User ID=root;Password=myPassword;Host=localhost;Port=3306;Database=myDataBase; Direct=true;Protocol=TCP;Compress=false;Pooling=true;Min Pool Size=0;Max Pool Size=100;Connection Lifetime=0;

<!--Nhibernate-->
<add name="name" 
     connectionString="Server= servername;Initial Catalog=DBname;UID=username;Password=password;MultipleActiveResultSets=true" 
     providerName="System.Data.SqlClient" /> 

<!--Entity Framework-->
<add name="name" 
     connectionString= "metadata=res://*/Models.Model1.csdl|res://*/Models.Model1.ssdl|res://*/Models.Model1.msl;provider=System.Data.SqlClient;provider connection string=&quot;data source=servername;initial catalog=DBname;user id=userName;password=password;multipleactiveresultsets=True;App=EntityFramework&quot;" 
     providerName="System.Data.EntityClient" /> 


### sqlserver 连接字符
https://docs.microsoft.com/en-us/dotnet/api/system.data.sqlclient.sqlconnection.connectionstring?view=dotnet-plat-ext-5.0
User Id=inet;Password=somePassw0rd;Data Source=TEST11;Min Pool Size=5;Max Pool Size=15;Pooling=True