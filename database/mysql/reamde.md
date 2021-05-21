* [mysqldba](https://github.com/zhishutech/mysqldba) MySQL DBA用得到的东西

##MySQL入门教程
https://github.com/jaywcjlove/mysql-tutorial

##mysqltools 权威指南
https://github.com/Neeky/mysqltools

##awesome-mysql
https://github.com/shlomi-noach/awesome-mysql


##中国5级行政区域mysql库
https://github.com/kakuilan/china_area_mysql


##基于canal 的 mysql 与 redis/memcached/mongodb 的 nosql 数据实时同步方案 案例 demo canal client
https://github.com/liukelin/canal_mysql_nosql_sync


##学习笔记
https://github.com/lyb411/mysql  mysql笔记、研究，常见问题


##如何选择合适存储引擎
(https://github.com/Melody12ab/db_mysql_note/blob/master/table_type_and_code.md)
MyISAM

以读和插入操作为主，只有很少跟新和删除，并对事务的完整性和并发性要求不高。

InnoDB

用于事务处理应用程序，支持外键。对事务和并发有要求，并且除了插入和查询还有不少更新和删除。

MEMORY

将所有数据放在RAM中，因此很快，但对大小有限制，用于更新不太频繁的小表。

MERGE

将MyISAM表组合，作为一个对象引用它们，可以突破对单个MyISAM表大小的限制。

## 备份表

### 方法1
create table bak_11 like org_user
insert into bak_11 select * from org_user

### 方法2
CREATE  TABLE IF NOT EXISTS tb_base_select SELECT * FROM tb_base; 

### 方法3
CREATE TABLE tb_base(
id INT NOT NULL PRIMARY KEY,
name VARCHAR(10),
KEY ix_name (name))
ENGINE='MyISAM',CHARSET=utf8,COMMENT 'a' ;

### 方法4
SELECT @rowNum:=0;
CREATE  TABLE IF NOT EXISTS qqb_base_selwwct SELECT @rowNum:=@rowNum + 1 AS rowid,a.file_id,a.file_name  FROM dms_file a,(SELECT @rowNum:=0) b  ORDER BY a.file_createTime desc;

## Mysql查询结果带行号
SELECT @rowNum:=0;
SELECT @rowNum:=@rowNum + 1 AS rowid,a.file_id,a.file_name  FROM dms_file a,(SELECT @rowNum:=0) b  ORDER BY a.file_createTime desc;


## MySQL数据库 之 添加一个字段并设置为自增主键gd
ALTER TABLE qqb_base_s55elsswwct ADD id INT(16) NOT NULL  PRIMARY KEY AUTO_INCREMENT FIRST;

# 3. 增加新用户：grant select on db_name.* to user_name@login_host identified by 'user_password'     [https://github.com/ycrao/mynotes/blob/master/mysql/basic.md]
/* mysql grant命令添加用户常用的三种模式 */
grant all PRIVILEGES on *.* to 'test'@'localhost' identified by 'password';
grant all PRIVILEGES on *.* to 'test'@'%' identified by 'password';
grant all PRIVILEGES on *.* to 'test'@'10.22.225.18' identified by 'password';


## 权限参考
![Privileges_ProvidedbyMySQL](Privileges_ProvidedbyMySQL.md)


#6. 增加字段：alter table table_name [ add field_name field_type / other_sql_expression ]
在表 user 中添加了一个字段 user_pic ，类型为 varchar(40)，默认值为 NULL alter table user add user_pic varchar(40) default NULL;

加索引 alter table employee add index emp_name (name);

加主关键字的索引 alter table employee add primary key(id);

加唯一限制条件的索引 alter table employee add unique emp_name2(cardnumber);

删除某个索引 alter table employee drop index emp_name;

增加字段 alter table user add user_pic varchar(40) default NULL;
mysql中修改字段长度 ALTER TABLE tb_article MODIFY COLUMN NAME VARCHAR(50);
修改原字段名称及类型 ALTER TABLE table_name CHANGE old_field_name new_field_name field_type;

删除字段 ALTER TABLE table_name DROP field_name;

alter table tname modify id int unsigned not null AUTO_INCREMENT;--为id增加自增索引
alter table tname engine=innodb;--修改表引擎(将该表修改为innodb引擎)
alter table tname engine=myisam;--修改表引擎
alter table tname CHARSET=utf8;--修改表字编码
ALTER TABLE  tname ADD age INT NOT NULL AFTER  'uid';--添加一个字段，在tname表中的uid之后age字段，整型，不为空
ALTER TABLE  tname ADD age INT NOT NULL;--添加一个字段,默认添加到最后
show index from org_user; -- MySQL 查看索引命令
show keys from org_user;-- MySQL 查看索引命令
# 8.备份数据库：
① 导出整个数据库，导出文件默认是存在mysql\bin目录下 mysqldump -u user_name -p user_password db_name > new_db_name.sql

② 导出一个表 mysqldump -u user_name -p user_password database_name table_name > outfile_name.sql

③ 导出一个数据库结构 mysqldump -u user_name -puser_password -d -add-drop-table database_name > outfile_name.sql -d 没有数据 -add-drop-table 在每个 create 语句之前增加一个 drop table

④带语言参数导出 mysqldump -u user_name -p user_password -default-character-set=latin1 -set-charset=gbk -skip-opt database_name > outfile_name.sql

## [OUTFILE 用法](https://jingyan.baidu.com/article/e75057f238ad34ebc91a8932.html)
load data infile '/tmp/stud.txt' into table students;
 -- select  user_account,user_id into outfile 'd:\\1.txt' from org_user 
SELECT   user_account,user_id,user_identityID,user_changeTime  FROM org_user INTO OUTFILE 'd:/t_user_2.txt'

FIELDS

TERMINATED BY ','

ENCLOSED BY '\"'

ESCAPED BY '\''

LINES

TERMINATED BY '\r\n';

# #将daochu.sql 导入到mysql数据库：
在终端运行：mysql -h localhost -u root -p test < /home/chuzj/daochu.sql --default-character-set=utf8　

## MySql查看表的创建时间
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dvpsmsdb01' ORDER BY create_time DESC;

## MySql创建数据库aa
CREATE DATABASE IF NOT EXISTS aa CHARACTER SET utf8 COLLATE utf8_general_ci;

- 不存在建表
CREATE TABLE IF NOT EXISTS student(id int unsigned not null primary key,name varchar(32) not null);MySQL官方对

- 备份表
drop table if exists bak_functions;
CREATE TABLE IF NOT EXISTS bak_functions SELECT * from org_function

## 表中列存在
show columns from dms_downfilelog like 'id'  

SELECT count(*)as a FROM(  
    select COLUMN_NAME from information_schema.COLUMNS   
        where TABLE_SCHEMA='db1'   
        and TABLE_NAME='dms_downfilelog'   
        and COLUMN_NAME='processstate'  
)  t



## 类型转换

SELECT  CONCAT('a',cast(123 as char),';-- user_id=',22) as n1;

## Mysql 中完善的帮助命令
select * from mysql.help_category;
help Help Metadata;
help AUTO_INCREMENT;


## --相差1天
　　select TIMESTAMPDIFF(DAY, '2018-03-20 23:59:00', '2015-03-22 00:00:00');
　　--相差49小时
　　select TIMESTAMPDIFF(HOUR, '2018-03-20 09:00:00', '2018-03-22 10:00:00');
　　--相差2940分钟
　　select TIMESTAMPDIFF(MINUTE, '2018-03-20 09:00:00', '2018-03-22 10:00:00');
　　--相差176400秒
　　select TIMESTAMPDIFF(SECOND, '2018-03-20 09:00:00', '2018-03-22 10:00:00');
　　--相差大于等于15秒
 　　SELECT * FROM 表名 WHERE   TIMESTAMPDIFF(SECOND,start_time(较小的时间),stop_time(较大的时间)) >= 15
 ## 当前时间
 ```sql
SELECT current_timestamp();
SELECT current_time();
SELECT CURRENT_DATE();
SELECT  now();
SELECT curdate();
SELECT curtime();
```


## MySQL审计日志
下载地址 https://bintray.com/mcafee/mysql-audit-plugin/release/1.1.4-725#files
https://github.com/mcafee/mysql-audit
解压插件包
 unzip audit-plugin-mysql-5.7-1.1.4-725.zip
将解压好的插件复制到 MySQL 的插件目录下
 cd audit-plugin-mysql-5.7-1.1.4-725/lib/
 cp libaudit_plugin.so /usr/local/mysql/lib/plugin/
root@localhost 18:18: [(none)]> install plugin audit soname 'libaudit_plugin.so';
root@localhost 18:19: [(none)]> show variables like '%audit_json_file%';
root@localhost 18:20: [(none)]> set global audit_json_file = 1;
show global status like 'AUDIT_version';

## 如何查看mysql执行的所有SQL
set global general_log='ON';
show variables like 'general_log%';

## 如何查看mysql字符集
show variables like '%char%';

## 数据库中查询一下连接数的配置情况
SELECT @@max_user_connections, @@max_connections, @@wait_timeout, @@interactive_timeout;

## 数据库表执行计划
explain select * from dms_user where user_name='xx';

## 查找表中多余的重复记录，重复记录是根据单
-- 查找表中多余的重复记录，重复记录是根据单个字段（peopleId）来判断
select * from people where peopleId in (select peopleId from people group by peopleId having count(peopleId) > 1)
-- 删除表中多余的重复记录，重复记录是根据单个字段（peopleId）来判断，只留有rowid最小的记录
delete from people 
where peopleId in (select peopleId from people group by peopleId having count(peopleId) > 1)
and rowid not in (select min(rowid) from people group by peopleId having count(peopleId )>1)
-- 查找表中多余的重复记录（多个字段）
select * from vitae a
where (a.peopleId,a.seq) in (select peopleId,seq from vitae group by peopleId,seq having count(*) > 1)
-- 删除表中多余的重复记录（多个字段），只留有rowid最小的记录
delete from vitae a
where (a.peopleId,a.seq) in (select peopleId,seq from vitae group by peopleId,seq having count(*) > 1) and rowid not in (select min(rowid) from vitae group by peopleId,seq having count(*)>1)
-- 查找表中多余的重复记录（多个字段），不包含rowid最小的记录
select * from vitae a
where (a.peopleId,a.seq) in (select peopleId,seq from vitae group by peopleId,seq having count(*) > 1) and rowid not in (select min(rowid) from vitae group by peopleId,seq having count(*)>1)
- [](https://github.com/jaywcjlove/mysql-tutorial/blob/master/21-minutes-MySQL-basic-entry.md)

## Insert into select请慎用
解决方案 [](https://www.cnblogs.com/javastack/p/13670978.html)
由于查询条件会导致order_today全表扫描，什么能避免全表扫描呢，很简单嘛，给pay_success_time字段添加一个idx_pay_suc_time索引就可以了，由于走索引查询，就不会出现扫描全表的情况而锁表了，只会锁定符合条件的记录。
关于 MySQL 索引的详细用法有实战，大家可以关注公众号Java技术栈在后台回复mysql获取系列干货文章。
最终的sql
INSERT INTO order_record SELECT  *  FROM  order_today FORCE INDEX (idx_pay_suc_time)   WHERE  pay_success_time <= '2020-03-08 00:00:00';
执行过程
总结
使用insert into tablA select * from tableB语句时，一定要确保tableB后面的where，order或者其他条件，都需要有对应的索引，来避免出现tableB全部记录被锁定的情况




## MySql 申明变量以及赋值
mysql中变量不用事前申明，在用的时候直接用“@变量名”使用就可以了。
第一种用法：set @num=1; 或set @num:=1; //这里要使用变量来保存数据，直接使用@num变量
第二种用法：select @num:=1; 或 select @num:=字段名 from 表名 where ……
注意上面两种赋值符号，使用set时可以用“=”或“：=”，但是使用select时必须用“：=赋值”
## MySQL自增主键归零的方法：
truncate table table_name; -- 如果曾经的数据都不需要的话，可以直接清空所有数据，并将自增字段恢复从1开始计数：
  2.  当用户没有truncate的权限时且曾经的数据不需要时：
     1）删除原有主键：
ALTER TABLE 'table_name' DROP 'id';
     2）添加新主键：
ALTER TABLE 'table_name' ADD 'id' int(11) NOT NULL FIRST;
    3）设置新主键：
ALTER TABLE 'table_name' MODIFY COLUMN 'id' int(11) NOT NULL AUTO_INCREMENT,ADD PRIMARY KEY(id);
 3. 当用户没有权限时：
    可以直接设置数据表的 AUTO_INCREMENT 值为想要的初始值，比如10000：
ALTER TABLE 'table_name' AUTO_INCREMENT= 10000;

## MySQL权限要求
参考：
Privileges权限	含义
CREATE	创建新的数据库和表的权限
REFERENCES	允许创建外键
INDEX	权限代表是否允许创建和删除索引
ALTER	允许修改表结构
CREATE ROUTINE	允许创建存储过程、函数的权限
ALTER ROUTINE	权限代表允许修改或者删除存储过程、函数的权限
EXECUTE	权限代表允许执行存储过程和函数的权限
CREATE VIEW	权限代表允许创建视图的权限
SHOW VIEW	权限代表通过执行show create view命令查看视图创建的语句
DROP	允许删除数据库、表、视图的权限
SELECT	数据查询
UPDATE	数据更新
INSERT	数据添加
DELETE	数据删除
### 1.1标准
1.1.1MySQL（含TIDB）需要以下权限
CREATE,REFERENCES,INDEX,ALTER,CREATE ROUTINE,ALTER ROUTINE,EXECUTE,CREATE VIEW,SHOW VIEW,DROP,SELECT,UPDATE,INSERT,DELETE
1.1.2授权代码参考
CREATE USER 'admin'@'%' IDENTIFIED BY 'password';
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'password';
GRANT CREATE,REFERENCES,INDEX,ALTER,CREATE ROUTINE,ALTER ROUTINE,EXECUTE,CREATE VIEW,SHOW VIEW,DROP,SELECT,UPDATE,INSERT,DELETE ON edoc2v5.* TO 'admin'@'%';
GRANT CREATE,REFERENCES,INDEX,ALTER,CREATE ROUTINE,ALTER ROUTINE,EXECUTE,CREATE VIEW,SHOW VIEW,DROP,SELECT,UPDATE,INSERT,DELETE ON edoc2v5.* TO 'admin'@'localhost';
GRANT SELECT ON mysql.* TO 'admin'@'%';
GRANT SELECT ON mysql.* TO 'admin'@'localhost';

### 1.2.1MySQL（含TIDB）需要以下权限
CREATE,INDEX,ALTER,DROP,SELECT,UPDATE,INSERT,DELETE
1.2.2授权代码参考
CREATE USER 'admin'@'%' IDENTIFIED BY 'password';
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'password';
GRANT CREATE,INDEX,ALTER,DROP,SELECT,UPDATE,INSERT,DELETE ON edoc2v5.* TO 'admin'@'%';
GRANT CREATE,INDEX,ALTER,DROP,SELECT,UPDATE,INSERT,DELETE ON edoc2v5.* TO 'admin'@'localhost';
GRANT SELECT ON mysql.* TO 'admin'@'%';
GRANT SELECT ON mysql.* TO 'admin'@'localhost';
![](./MySQL 新建用户为用户授权指定用户访问数据.sql)

## 资源
- [mysqltools](https://github.com/Neeky/mysqltools)一个用于快速构建大规模，高质量，全自动化的 mysql分布式集群环境的工具；包含mysql 安装、备份、监控、高可用、读写分离、优化、巡检、自行化运维
- [MySQL 资源大全中文版](https://github.com/jobbole/awesome-mysql-cn)MySQL 资源大全中文版
- [mysql2sqlite](https://github.com/dumblob/mysql2sqlite)
- [awesome-mysql](https://github.com/jaywcjlove/mysql-tutorial/blob/master/awesome-mysql.md)MySQL入门教程
- [SQL-exercise](https://github.com/XD-DENG/SQL-exercise) 适合入门到精通练习
- [数据实时同步方案 ](https://github.com/liukelin/canal_mysql_nosql_sync)基于canal 的 mysql 与 redis/memcached/mongodb 的 nosql 数据实时同步方案 案例 demo canal client
- [mysql注入](https://github.com/aleenzz/MYSQL_SQL_BYPASS_WIKI)  mysql注入,bypass的一些心得
- [dbatools 性能测试](https://github.com/xiepaup/dbatools)  About-MySQL/Linux/Redis Tools
- [死锁](https://github.com/aneasystone/mysql-deadlocks) 在工作过程中偶尔会遇到死锁问题，虽然这种问题遇到的概率不大，但每次遇到的时候要想彻底弄懂其原理并找到解决方案却并不容易


## tidb 与 MySQL 兼容性对比
https://docs.pingcap.com/zh/tidb/stable/mysql-compatibility#%E4%B8%8D%E6%94%AF%E6%8C%81%E7%9A%84%E5%8A%9F%E8%83%BD%E7%89%B9%E6%80%A7


## MySQL中中的整数类型int主要有如下几种：
1、tinyint 的范围是-128~127；
2、int的范围是-2^31 (-2,147,483,648) 到 2^31 – 1 (2,147,483,647) 的整型数据（所有数字），存储大小为4个字节；
3、bigint的范围是 -2^63 (-9223372036854775808) 到 2^63-1 (9223372036854775807) 的整型数据（所有数字）。存储大小为 8 个字节；
4、smallint unsigned的范围是 –2^15（2^15表示2的15次幂） 到2^15 – 1，即 –32768 到 32767；
5、smallint 的范围是 0 到 2^16 – 1，即 0 到 65535，存储的字节是2个字节

## mysql 主从同步
执行如下sql，查看数据库集群状态，如下为正常状态
select * from  performance_schema.replication_group_members;

查看从服务器状态：
show slave status
![](https://segmentfault.com/a/1190000022115647)